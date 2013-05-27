package com.squidzoo.friendify.helpers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	
	public class ImageResizeUtils extends EventDispatcher
	{
		public function ImageResizeUtils(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function scaleBitmapData(_bmd:BitmapData, 
										 targetContainerWidth:Number, targetContainerHeight:Number=0):Bitmap { 
			//set matrix sx & sy 
			var sx:Number = targetContainerWidth / _bmd.width; 
			var sy:Number = 0;
			
			if(targetContainerHeight==0){
				sy = sx;			
				targetContainerHeight = _bmd.height * sy;
				
			}else{
				sy = targetContainerHeight / _bmd.height; 				
			}
			
			//instantiate new matrix, and set scaling 
			var m:Matrix = new Matrix(); 
			m.scale(sx, sy); 
			
			//create new bitmapdata	
			var newBmd:BitmapData = new BitmapData(targetContainerWidth, targetContainerHeight); 
			//draw new bitmapdata with matrix	
			newBmd.draw(_bmd, m); 
			//create final bitmap with new bitmapdata 
			var newBmp:Bitmap = new Bitmap(newBmd); 
			//set smooting to true 
			newBmp.smoothing = true; 
			
			return newBmp; 
		}
		
		public function scalePhotoToTargetWidth(image:Bitmap,targetContainerWidth:int):Bitmap{
			
			var scaleFactor:Number = targetContainerWidth / image.width; 
			var targetContainerHeight:Number = scaleFactor * image.height;
			
			var scaleParams:Matrix = new Matrix(); 
			scaleParams.scale(scaleFactor,scaleFactor); 
			
			var newBmd:BitmapData = new BitmapData(targetContainerWidth, targetContainerHeight); 
			//draw new bitmapdata with matrix	
			newBmd.draw(image.bitmapData, scaleParams); 
			//create final bitmap with new bitmapdata 
			var newBmp:Bitmap = new Bitmap(newBmd); 
			//set smooting to true 
			newBmp.smoothing = true; 
			
			return newBmp; 
		}
		
		public function scalePhotoToTargetHeight(image:Bitmap, targetContainerHeight:int):Bitmap
		{
			var scaleFactor:Number = targetContainerHeight / image.height;
			var targetContainerWidth:Number = scaleFactor * image.width;
			
			var scaleParams:Matrix = new Matrix(); 
			scaleParams.scale(scaleFactor,scaleFactor); 
			//test
			targetContainerWidth = 100,targetContainerHeight = 100;
			var newBmd:BitmapData = new BitmapData(targetContainerWidth, targetContainerHeight,true,0xffffff); 
			//draw new bitmapdata with matrix	
			newBmd.draw(image.bitmapData, scaleParams); 
			//create final bitmap with new bitmapdata 
			var newBmp:Bitmap = new Bitmap(newBmd); 
			//set smooting to true 
			newBmp.smoothing = true; 
			
			return newBmp; 
		}
		
	}
}