package com.squidzoo.utils
{
	import com.flexnroses.mobile.utils.hardware.ExifUtils.ExifUtils;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.MediaPromise;
	import flash.net.URLRequest;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.ExifLoader;
	
	
	public class PhotoRotator extends EventDispatcher
	{
	public static const IMAGE_AVAILABLE:String = "Image Available";
	public static const ROTATION_PROCESS_ERROR:String = "Rotation process error";
	
	public var selectedImage:Bitmap;
	private var _loader:Loader;
	private var _exifLoader:ExifLoader;
	private var _mediaPromise:MediaPromise;
		
		
	public function PhotoRotator(mediaPromise:MediaPromise):void{
		_mediaPromise = mediaPromise;
		_loader=new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoadedHandler);
		
		_exifLoader=new ExifLoader();
		_exifLoader.addEventListener(Event.COMPLETE, completeHandler);
		_exifLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		_exifLoader.load(new URLRequest(_mediaPromise.file.url));
	}
	
	private function completeHandler(event:Event):void
	{
		_loader.unload();
		_loader.loadFilePromise(_mediaPromise);
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
			onIOError(); 
		}
		else
		{
			selectedImage = ExifUtils.getEyeOrientedBitmap(Bitmap(event.currentTarget.content), exif.ifds);
			dispatchEvent(new Event(PhotoRotator.IMAGE_AVAILABLE));
		}
	}
	
	//if exifLoader fails, use standard Loader
	protected function onIOError(event:IOErrorEvent=null):void
	{
		var loader:Loader=new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete);
		loader.load(new URLRequest(_mediaPromise.file.url));
	}
	
	//listen for standard loader event completion
	protected function onImageLoadComplete(event:Event):void
	{
		selectedImage = event.target.content as Bitmap;
		dispatchEvent(new Event(PhotoRotator.IMAGE_AVAILABLE));
	}

		
		
	}
}