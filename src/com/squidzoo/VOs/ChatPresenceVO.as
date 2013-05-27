package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	
	import org.igniterealtime.xiff.core.EscapedJID;
	
	[Bindable]
	public class ChatPresenceVO extends EventDispatcher
	{
		public var id:String;
		public var name:String;
		
		public function ChatPresenceVO(id:String):void{
			this.id = id;
			trace("ChatPresenseVO.id: "+id);
		}
		
	}
}