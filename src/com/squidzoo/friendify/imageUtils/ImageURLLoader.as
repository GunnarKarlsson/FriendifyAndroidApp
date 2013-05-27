package com.squidzoo.friendify.imageUtils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class ImageURLLoader extends EventDispatcher
	{
		public static const LOAD_COMPLETE:String = "load_complete";
		
		private var loader:Loader;
		public var bitmap:Bitmap;
	
		public function load(url:String):void{
			loader = new Loader();
			var urlRequest:URLRequest = new URLRequest(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError)
			loader.load(urlRequest);
		}
		
		protected function onLoadError(event:IOErrorEvent):void
		{
			trace("error loading");
		}
		
		protected function onComplete(event:Event):void
		{
			bitmap = loader.content as Bitmap;
			this.dispatchEvent(new Event(ImageURLLoader.LOAD_COMPLETE));
		}
	
	}
}