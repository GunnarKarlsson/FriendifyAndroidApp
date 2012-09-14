package services
{
	import com.flexnroses.mobile.utils.hardware.ExifUtils.ExifUtils;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.ExifLoader;
	
	import spark.components.Image;

	public class PhotoTaker extends Sprite
	{

		public static const TAKE_PHOTO_ERROR:String="Error taking photo";
		public static const TAKE_PHOTO_SUCCESS:String="Photo is available";

		public var fileReference:FileReference;
		public var url:String;
		[Bindable]
		public var selectedImage:Bitmap;
		public var mediaPromise:MediaPromise;

		private var _camera:CameraUI;
		private var _loader:Loader;

		private var _exifLoader:ExifLoader;

		public function takePhoto():void
		{
			if (CameraUI.isSupported)
			{
				_loader=new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoadedHandler);

				_camera=new CameraUI();
				_camera.addEventListener(MediaEvent.COMPLETE, onComplete);
				_camera.launch(MediaType.IMAGE);
			}
		}

		private function onComplete(event:MediaEvent):void
		{
			//url=event.data.file.url;
			//selectedImage.source = event.data.file.url;
			mediaPromise=event.data;
			fileReference=mediaPromise.file;
			//dispatchEvent(new Event(PhotoTaker.TAKE_PHOTO_SUCCESS));
			_exifLoader=new ExifLoader();
			_exifLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_exifLoader.addEventListener(Event.COMPLETE, onExifCompleteHandler);
			_exifLoader.load(new URLRequest(mediaPromise.file.url ));
		}

		private function onExifCompleteHandler(event:Event):void
		{
			_loader.unload();
			_loader.loadFilePromise(mediaPromise);
		}



		private function errorHandler(event:Event=null):void
		{
			dispatchEvent(new Event(PhotoTaker.TAKE_PHOTO_ERROR));
		}

		private function contentLoadedHandler(event:Event):void
		{
			var exif:ExifInfo=_exifLoader.exif;

			if (!exif.ifds)
			{
			}

			var rotation:int=ExifUtils.getEyeOrientedAngle(exif.ifds);

			if (rotation == -1)
			{
				onIOError(); 			}
			else
			{
				selectedImage = ExifUtils.getEyeOrientedBitmap(Bitmap(event.currentTarget.content), exif.ifds);
				dispatchEvent(new Event(PhotoTaker.TAKE_PHOTO_SUCCESS));
			}
		}

		//if exifLoader fails, use standard Loader
		protected function onIOError(event:IOErrorEvent=null):void
		{
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete);
			loader.load(new URLRequest(mediaPromise.file.url));
		}

		//listen for standard loader event completion
		protected function onImageLoadComplete(event:Event):void
		{
			selectedImage = event.target.content as Bitmap;
			dispatchEvent(new Event(PhotoTaker.TAKE_PHOTO_SUCCESS));
		}
	}


}
