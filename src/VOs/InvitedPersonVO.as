package VOs
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;
	
	import spark.components.Image;
	
	[Bindable]
	public class InvitedPersonVO extends EventDispatcher
	{
		public var name:String;
		public var id:String;
		public var type:String;
		
		public var rsvp:String;
	
		public function FriendVO(name:String,id:String):void{
			this.id = id;
			this.name = name;
			this.type = "friend";
		}
	}
}