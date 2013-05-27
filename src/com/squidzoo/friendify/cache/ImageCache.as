package com.squidzoo.friendify.cache
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class ImageCache extends EventDispatcher{
		public static const IMAGE_DATA_ABSENT:int = 0;
		public static const IMAGE_DATA_PRESENT:int = 2;

		public static const IMAGE_SIZE_SQUARE:String = "imageSizeSquare";	//50x50 px
		public static const IMAGE_SIZE_SMALL:String  = "imageSizeSmall";	//50 x variable px
		public static const IMAGE_SIZE_NORMAL:String = "imageSizeNormal";	//100 x variable px
		public static const IMAGE_SIZE_LARGE:String = "imageSizeLarge";  	//200 x variable px
		
		private static const _instance:ImageCache = new ImageCache();
		
		private var _bitmapDataRepository:Dictionary;
		
		public function ImageCache() {
			if(_instance != null) {
				throw new Error("This is a singleton class, use ImageCache.getInstance() " +
					"to get the singleton instance");
			}			
			
			_bitmapDataRepository = new Dictionary();
		}
		
		public static function getInstance():ImageCache {
			return _instance;
		}
		
		public function getImageData(imageId:String,size:String):Bitmap{
			var bitmapData:BitmapData;
			if((imageId +size)!= null) {
				bitmapData = _bitmapDataRepository[(imageId+size)]; 
			}
			return new Bitmap(bitmapData); 
		}
		
		public function putImageData(imageId:String, size:String,image:Bitmap):void {
			var imageData:BitmapData = image.bitmapData;
			if((imageId+size) != null && imageData != null) {				
				_bitmapDataRepository[(imageId+size)] = imageData;
				
			}
		}
		
		public function hasImageData(imageId:String,size):Boolean {
			if((imageId+size) != null) {
				var bitmapData:BitmapData = _bitmapDataRepository[(imageId+size)];
				if(bitmapData != null) {
					return true;
				}
			}
			return false;
		}
		
		public function purgeImageData(imageId:String,size:String):void {
			if((imageId+size) != null) {				
				var bitmapData:BitmapData = _bitmapDataRepository[(imageId+size)];
				if(bitmapData != null) {
					bitmapData.dispose();
				}
				delete _bitmapDataRepository[(imageId+size)];
			}
		}
		
		public function clear():void {
			var bitmapData:BitmapData;
			for(var key:Object in _bitmapDataRepository) {
				bitmapData = _bitmapDataRepository[key];
				if(bitmapData != null) {
					bitmapData.dispose();
				}
				delete _bitmapDataRepository[key];
				key = null;
			}			
		}
	}
}