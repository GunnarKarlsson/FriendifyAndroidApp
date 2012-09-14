package com.squidzoo.eventSystem.events
{
	import flash.events.Event;
	
	public class CustomDataEvent extends Event {
		
		public static const NEW_ALBUM_NAME:String = "New Album Name";
		public static const NEW_ALBUM_DESC:String = "New Album Desc";
		
		public static const NEW_FRIENDS_SEARCH_NAME:String = "New Friends Search Name";
		public static const NEW_FRIENDS_SEARCH_SCOPE:String = "New Friends Search Scope";
		
		public static const PUSH_SINGLE_USER_VIEW:String = "Push single user view";
		
		public static const PUSH_SINGLE_EVENT_VIEW:String = "Push single event view";
		
		public static const MAIN_MENU_BUTTON_CLICKED:String = "Main menu button clicked";
		
		public static const MAIN_MENU_SELECTION:String = "Main menu selection";
		
		public static const LOCATION_SELECTED:String = "Location selected";
		
		public static const NEW_USER_COMMENT:String = "New User Comment";
		
		public static const PUSH_NEWSFEED:String = "push newsfeed";
		
		public static const NEW_WALL_POST_MESSAGE:String = "new wall post message";
		
		public static const COMMENT_DELETED:String = "comment deleted";
		
		public static const START_NOTIFICATION_POLLING:String = "Start notification polling";
		
		public static const NOTIFICATION_TAPPED_IN_STATUS_BAR:String = "Notification tapped in status bar";
		
		public static const NOTIFICATION_POLLING_CONFIGURATION_CHANGE:String = "Notification Polling configuration change";
		
		public static const DELETE_NOTIFICATION:String = "delete notification";
		
		public static const NOTIFICATION_IR_CLICKED_VIEW_MORE:String = "Notification ir clicked view more";
		
		public var data:String;
		public var dataObject:Object;
		
		public function CustomDataEvent(type:String,value:String,obj:Object=null):void {
			
			super(type,true);
			
			data = value;
			dataObject = obj;
		}
	}
}