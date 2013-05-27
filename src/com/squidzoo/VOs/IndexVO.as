package com.squidzoo.VOs
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;
		
	[Bindable]
	public class IndexVO extends EventDispatcher
	{
		public var type:String = "index";
		public var letter:String;
	
		public function IndexVO(letter:String):void{
			this.letter = letter.toUpperCase();
		}
	}
}