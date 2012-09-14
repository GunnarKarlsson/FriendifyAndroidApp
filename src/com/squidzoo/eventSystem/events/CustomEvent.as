package com.squidzoo.eventSystem.events
{
	import flash.events.Event;

	public class CustomEvent extends Event {
		
		public static const LIKES_DATA_FOR_NEWSFEED_AVAILABLE:String = "Likes data for newsfeed available";
		public static const PUSH_HOME_VIEW:String = "Push home view";
		public static const LOG_OUT_CLICKED:String = "Logout clicked";
		public static const MATRIX:String = "Matrix";
		
		public function CustomEvent(type:String):void {
			super(type);
		}
	}
}