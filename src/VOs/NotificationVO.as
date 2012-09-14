package VOs
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;

	[Bindable]
	public class NotificationVO extends EventDispatcher
	{
		public var createdTimes:String;
		public var from:PersonVO;
		public var id:String;
		public var link:String;
		public var title:String;
		public var to:PersonVO;
		public var unread:int;
		public var updatedTime:String;
		public var application:Object = new Object();
		public var icon:*;
		public var message:*;
		public var label:*;
		
		public function NotificationVO(id:String)
		{
			this.id = id;
			/*
			var query:String = "SELECT notification_id, sender_id, title_html, body_html, object_type, object_id " +
				"FROM notification " +
				"WHERE recipient_id=me()"
			
			FacebookMobile.fqlQuery(query,handleQuery);
			*/
		}
		/*
		private function handleQuery(success:Object,fail:Object):void
		{
			
			if(success){
				var response:Array = success as Array;
				for(var i:uint = 0;i < response.length;i++){
					trace("fbs object_id: "+response[i].object_id);
					trace("fbs object_type: "+response[i].object_type);
				}
			}
			// TODO Auto Generated method stub
		}
		*/
	}
}