package VOs
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class PhotoVO extends EventDispatcher
	{
		public var type:String = "PhotoVO";
		
		public var sourceXtraLarge:String;
		public var sourceLarge:String;
		public var sourceMedium:String;
		public var sourceSmall:String;
		public var thumbnailURL:String;
		public var id:String;
		public var name:String;
		public var likes:Object;
		public var comments:Object;
		public var likesCount:int;
		public var commentsCount:int;
		
		public function PhotoVO(id:String):void{
			this.id = id;
			//FacebookMobile.api(id+"/likes",handleLikes);
		}
		
		/*
		private function handleLikes(success:Object,fail:Object):void
		{
			if(success){
				likes = success;
				likesCount = success.length;
				trace(success);
			}
			
			FacebookMobile.api(id+"/comments",handleComments);
		}
		
		private function handleComments(success:Object,fail:Object):void{
			if(success){
				comments = success;
				commentsCount = success.length;
			}
		}
		*/
	}
}