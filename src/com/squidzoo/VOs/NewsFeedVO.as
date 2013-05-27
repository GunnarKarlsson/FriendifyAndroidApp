package com.squidzoo.VOs
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class NewsFeedVO extends EventDispatcher
	{
		
		public var type:String;

		public var id:String;
		public var from:PersonVO;
		public var message:String;//may contain url
		public var picture:String;//url
		public var link:String;//url
		public var name:String;
		public var caption:String;
		public var description:String;
		public var icon:String;//url
		public var actions:ActionsVO;
		public var created_time:String;
		public var updated_time:String;	
		public var likesCount:int;
		public var userLikesIt:Boolean;
		public var commentsCount:int;
		public var comments:Object = new Object();
		public var place:Object = new Object();
		public var story:String;
		public var storyTags:Object;
				
		public var pullDownState:String = "";
	}
}