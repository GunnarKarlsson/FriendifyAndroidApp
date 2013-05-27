package com.squidzoo.friendify.helpers
{
	import mx.collections.ArrayCollection;

	public class ViewPersistenceManager
	{
		public static var newsFeedViewIsCreated:Boolean = false;
		
		public static var newsFeedDataProvider:ArrayCollection = new ArrayCollection();
		
		public function ViewPersistenceManager()
		{
		}
	}
}