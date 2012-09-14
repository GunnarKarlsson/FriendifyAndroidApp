package services
{
	import com.flexnroses.mobile.utils.hardware.ExifUtils.*;
	import com.squidzoo.debug.DebugEvent;
	import com.squidzoo.eventSystem.EventCentral;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.ExifLoader;
	
	import mx.events.FlexEvent;
	
	import utils.PhotoRotator;

	/*
	* Listen for IMAGE_SELECTION_SUCCESS, then get image from public properties fileReference (for upload) and selectedImage(for display);
	* Image is automatically rotated right way based on exif data
	*/
	
	public class GalleryBrowser extends Sprite
	{

		public static const ACCESS_CAMERA_ROLL_ERROR:String = "Unable to access camera roll";
		public static const CHOOSE_FILE_ERROR:String = "Unable to pick file";
		public static const IMAGE_SELECTION_SUCCESS:String = "Image selection success";
		
		public var fileReference:FileReference;
		public var selectedImage:Bitmap;

		private var loader:Loader;
		private var cameraRoll:CameraRoll;
		private var exifLoader:ExifLoader;
		private var mediaPromise:MediaPromise;
		private var photoRotator:PhotoRotator;

		public function GalleryBrowser()
		{

		}

		public function browse():void
		{
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE, "browse"));

			if (CameraRoll.supportsBrowseForImage)
			{
				loader=new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoadedHandler);

				cameraRoll=new CameraRoll();
				cameraRoll.addEventListener(MediaEvent.SELECT, mediaSelectHandler);
				cameraRoll.addEventListener(Event.CANCEL, errorHandler);
				cameraRoll.browseForImage();
			}
			else
			{
				trace("Unable to access Camera Roll");
				dispatchEvent(new Event(GalleryBrowser.ACCESS_CAMERA_ROLL_ERROR));
			}
		}

		private function mediaSelectHandler(event:MediaEvent):void
		{
			mediaPromise=event.data;
			fileReference=mediaPromise.file;
	
			this.exifLoader=new ExifLoader();
			this.exifLoader.addEventListener(Event.COMPLETE, completeHandler);
			this.exifLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.exifLoader.load(new URLRequest(mediaPromise.file.url));
		}

		private function errorHandler(event:Event):void
		{
			dispatchEvent(new Event(GalleryBrowser.CHOOSE_FILE_ERROR));
		}

		//3. once Exif data is available, use loader to obviously load mediaPromised found in step 2
		private function completeHandler(event:Event):void
		{
			//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE, "completeHandler"));
			loader.unload();
			loader.loadFilePromise(mediaPromise);
		}

		//4. use exif data and access ExifUtils to get the image found appear eye oriented.
		private function contentLoadedHandler(event:Event):void
		{
			//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 1"));

			var exif:ExifInfo=this.exifLoader.exif;

			if (!exif.ifds)
			{
				//trace("here");
				//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE, "contentLoadedHandler 1.5,Exif == null"));
			}

			//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 2"));

			var rotation:int=ExifUtils.getEyeOrientedAngle(exif.ifds);

			if (rotation == -1)
			{
				onIOError(); //EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler -1"));
			}
			else
			{
				//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 3"));
				//i created a new bitmap, but otherwise, you could also make use of the line above and 
				//distor the image in your own way.
				selectedImage = ExifUtils.getEyeOrientedBitmap(Bitmap(event.currentTarget.content), exif.ifds);

				dispatchEvent(new Event(GalleryBrowser.IMAGE_SELECTION_SUCCESS));
				//dispatchEvent(new CustomDataEvent(CustomDataEvent.GALLERY_IMAGE_SELECTED, _fileRef, selectedImage));
			}
		}

		//if exifLoader fails, use standard Loader
		protected function onIOError(event:IOErrorEvent=null):void
		{
			//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE, "onIOError"));
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete);
			loader.load(new URLRequest(mediaPromise.file.url));
		}

		//listen for standard loader event completion
		protected function onImageLoadComplete(event:Event):void
		{
			//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE, "onImageLoadComplete"));
			selectedImage = event.target.content as Bitmap;
			//dispatchEvent(new CustomDataEvent(CustomDataEvent.GALLERY_IMAGE_SELECTED, _fileRef, selectedImage));
			dispatchEvent(new Event(GalleryBrowser.IMAGE_SELECTION_SUCCESS));
		}
	}
}







