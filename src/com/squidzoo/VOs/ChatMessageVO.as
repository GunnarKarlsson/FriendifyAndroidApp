package com.squidzoo.VOs
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class ChatMessageVO extends EventDispatcher
	{
		public var from:Object = new Object();
		public var time:String;
		public var body:String;
		
		public function ChatMessageVO(id:String,parse:Boolean=true):void{
			if(parse==true){
				var pattern:RegExp = /\b\d+\b/;
				var uid:String = id.match(pattern).toString();
				from.id = uid;
			}else{
				from.id = id;
			}
		}
		
	
	}
}