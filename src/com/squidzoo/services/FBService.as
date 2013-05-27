package com.squidzoo.services
{
	import com.squidzoo.VOs.ActionsVO;
	import com.squidzoo.VOs.AlbumVO;
	import com.squidzoo.VOs.CommentVO;
	import com.squidzoo.VOs.EventVO;
	import com.squidzoo.VOs.FriendVO;
	import com.squidzoo.VOs.GroupVO;
	import com.squidzoo.VOs.InvitedPersonVO;
	import com.squidzoo.VOs.NewsFeedVO;
	import com.squidzoo.VOs.NotificationVO;
	import com.squidzoo.VOs.PersonVO;
	import com.squidzoo.VOs.PhotoVO;
	import com.squidzoo.VOs.PlaceVO;
	
	import com.chewtinfoil.utils.StringUtils;
	import com.facebook.graph.FacebookMobile;
	import com.squidzoo.eventSystem.EventCentral;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.GeolocationEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLVariables;
	import flash.sensors.Geolocation;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import com.squidzoo.views.loginLogout.LoginView;

	public class FBService extends EventDispatcher
	{
		public static const INIT_SUCCESS:String="init success";
		public static const INIT_ERROR:String="init error";

		public static const LOGIN_ERROR:String="Login error";
		public static const LOGIN_SUCCESS:String="You are logged in";

		public static const LOGOUT_SUCCESS:String="Logout success";
		public static const LOGOUT_ERROR:String="Logout error";

		public static const GET_ALBUMS_SUCCESS:String="Your Albums have been retrieved";
		public static const GET_ALBUMS_ERROR:String="Error getting albums";

		public static const GET_PHOTOS_IN_ALBUM_SUCCESS:String="Your album photos have been retrieved";
		public static const GET_PHOTOS_IN_ALBUM_ERROR:String="Error getting photos in album";

		public static const GET_FRIENDS_LIST_SUCCESS:String="Your friends list has been retrieved";
		public static const GET_FRIENDS_LIST_ERROR:String="Error getting friends list";

		public static const GET_NEEWSFEED_SUCCESS:String="Your newsfeed has been retrieved";
		public static const GET_NEWSFEED_ERROR:String="Error getting newsfeed";

		public static const GET_MESSAGES_SUCCESS:String="Your messages have been retrieved";
		public static const GET_MESSAGES_ERROR:String="Error getting messages";

		public static const GET_WALL_SUCCESS:String="Your wall has been retrieved";
		public static const GET_WALL_ERROR:String="Error getting wall";

		public static const GET_CHECKINS_SUCCESS:String="Your friends' checkins have been retrieved";
		public static const GET_CHECKINS_ERROR:String="Error getting your friends checkins";

		public static const GET_PLACE_SUCCESS:String="Get place success";
		public static const GET_PLACE_ERROR:String="Get place error";

		public static const GET_LIKES_DATA_FOR_NEWSFEED_SUCCESS:String="Get likes data for newsfeed success";
		public static const GET_LIKES_DATA_FOR_NEWSFEED_ERROR:String="Get likes data for newsfeed error";

		public static const GET_GEOLOCATION_SUCCESS:String="Get geolocation success";
		public static const GET_GEOLOCATION_ERROR:String="Get geolocation error";

		public static const GEOLOCATION_IS_AVAILABLE:String="Geolocation is available";
		public static const GEOLOCATION_ERROR_NOT_TURNED_ON:String="geolocation not turned on";
		public static const GEOLOCATION_NOT_SUPPORTED:String="Geolocation not supported";

		public static const GET_NEARBY_LOCATIONS_SUCCESS:String="Get nearby locations success";
		public static const GET_NEARBY_LOCATIONS_ERROR:String="Get nearby locations error";

		public static const GET_NOTIFICATIONS_SUCCESS:String="Get notifications success";
		public static const GET_NOTIFICATIONS_ERROR:String="Get notifications error";

		public static const NO_NEWSFEED_SEARCH_RESULTS_FOUND:String="No search results found";

		public static const GET_USER_DATA_SUCCESS:String="Get user data success";
		public static const GET_USER_DATA_ERROR:String="Get user data error";

		public static const GET_COMMENTS_SUCCESS:String="Get comments success";
		public static const GET_COMMENTS_ERROR:String="Get comments error";

		public static const GET_GROUPS_SUCCESS:String="Get groups success";
		public static const GET_GROUPS_ERROR:String="Get groups error";

		public static const GET_EVENTS_SUCCESS:String="Get events success";
		public static const GET_EVENTS_ERROR:String="Get events error";

		public static const GET_SINGLE_EVENT_SUCCESS:String="Get single event success";
		public static const GET_SINGLE_EVENT_ERROR:String="Get single event error";

		public static const GET_EVENT_INVITED_SUCCESS:String="Get event attendees success";
		public static const GET_EVENT_INVITED_ERROR:String="Get event attenddes errro";

		public static const GET_GROUP_MEMBERS_SUCCESS:String="Get group members success";
		public static const GET_GROUP_MEMBERS_ERROR:String="Get group members error";

		public static const GET_NEWSFEED_PHOTOS_SUCCESS:String="Get newsfeed photos success";
		public static const GET_NEWSFEED_PHOTOS_ERROR:String="Get newsfeed photos error";

		public static const COMMENT_POST_SUCCESS:String="Comment post success";
		public static const COMMENT_POST_ERROR:String="Comment post error";

		public static const SEARCH_EVERYONE_SUCCESS:String="Search everyone success";
		public static const SEARCH_EVERYONE_ERROR:String="Search everyone error";

		public static const GET_SOURCE_OBJECT_SUCCESS:String="Get source object success";
		public static const GET_SOURCE_OBJECT_ERROR:String="Get source object error";
		
		public static const POST_CHECKIN_SUCCESS:String = "Post checkin success";
		public static const POST_CHECKIN_ERROR:String = "Post checkin error";

		public static const POLL_NOTIFICATIONS_SUCCESS:String = "Poll notifications success";
		public static const POLL_NOTIFICATIONS_ERROR:String = "Poll notifications error";
		
		public var userName:String;

		public var friend:FriendVO;
		public var singleEvent:EventVO;
		public var place:Object=new Object();

		public var photoAlbums:Array=new Array();
		public var photosInAlbum:ArrayCollection=new ArrayCollection();
		public var friends:ArrayCollection=new ArrayCollection();
		public var newsFeed:ArrayCollection=new ArrayCollection();
		public var messages:ArrayCollection=new ArrayCollection();
		public var wallItems:ArrayCollection=new ArrayCollection();
		public var checkinItems:ArrayCollection=new ArrayCollection();
		public var nearbyLocations:ArrayCollection=new ArrayCollection();
		public var notifications:ArrayCollection=new ArrayCollection();
		public var comments:ArrayCollection=new ArrayCollection();
		public var events:ArrayCollection=new ArrayCollection();
		public var invitedToEvent:ArrayCollection=new ArrayCollection();
		public var groups:ArrayCollection=new ArrayCollection();
		public var groupMembers:ArrayCollection=new ArrayCollection();
		public var newsFeedPhotos:ArrayCollection=new ArrayCollection();
		public var searchEveryoneResult:ArrayCollection=new ArrayCollection();

		public var placeCache:Object=new Object();
		public var newsFeedCache:Object=new Object();
		public var photoCache:Object=new Object();
		public var locationObject:Object=new Object();
		public var sourceObject:Object = new Object();

		private var _geoLocation:Geolocation;
		private var _appID:String="app_id_here"; //friendify girly dots
		private var _webView:StageWebView;
		private var _permissions:Array=['read_stream', 'publish_stream', 'friends_checkins', 'xmpp_login', 'offline_access', 'publish_checkins', 'create_event', 'rsvp_event', 'sms', 'offline_access', 'email', 'read_insights', 'read_stream', 'user_about_me', 'user_activities', 'user_birthday', 'user_education_history', 'user_events', 'user_groups', 'user_hometown', 'user_interests', 'user_likes', 'user_location', 'user_notes', 'user_online_presence', 'user_photo_video_tags', 'user_photos', 'user_relationships', 'user_religion_politics', 'user_status', 'user_videos', 'user_website', 'user_work_history', 'read_friendlists', 'read_requests', 'user_notes', 'read_mailbox', 'manage_notifications', 'friends_about_me', 'friends_activities', 'friends_birthday', 'friends_checkins', 'friends_education_history', 'friends_events', 'friends_games_activity', 'friends_groups', 'friends_hometown', 'friends_interests', 'friends_likes', 'friends_location', 'friends_notes', 'friends_online_presence', 'friends_photos', 'friends_questions', 'friends_relationship_details', 'friends_relationships', 'friends_religion_politics', 'friends_status', 'friends_subscriptions', 'friends_videos', 'friends_website', 'friends_work_history'];
		private var _nextNewsFeedPage:String;
		private var _nextCommentsPage:String;
		private var _nextSearchEveryonePage:String;

		private var _searchEveryoneResultObject:Object=new Object();

		public function FBService()
		{
			super();
		}

		/*
		* public API
		*/

		/*
		* initialize()
		* Events: INIT_SUCCESS, INIT_ERROR
		*/

		public function initialize(loginView:LoginView):void
		{
			FacebookMobile.init(_appID, handleInit);
		}

		/*
		 * login()
		 * Events: LOGIN_SUCCESS, LOGIN_ERROR
		 */

		public function login():void
		{
			_webView=new StageWebView();
			_webView.stage=FlexGlobals.topLevelApplication.stage;
			_webView.viewPort=new Rectangle(0, 100, int(FlexGlobals.topLevelApplication.stage.stageWidth), 700);
			FacebookMobile.login(loginHandler, FlexGlobals.topLevelApplication.stage, _permissions, _webView);
		}


		/*
		* logout()
		* Events LOGOUT_SUCCESS, LOGOUT_ERROR
		*/

		public function logout():void
		{
			FacebookMobile.logout(handleLogout, "http://www.squidzoo.com");
		}
		
		public function getSourceObject(id:String):void{
			FacebookMobile.api(id,handleGetSourceObject);
		}


		public function searchEveryone(params:Object):void
		{
			FacebookMobile.api("search", handleSearchEveryone, params);
		}


		public function postToFeed(message:String, id:String=null):void{
			var params:Object = new Object();
			params.message = message;
			if(id==null){
				FacebookMobile.api("me/feed",handlePostToFeed,params,'POST');
			}else{
				FacebookMobile.api(id+"/feed",handlePostToFeed,params,'POST');
			}
		}
		
		public function getNextSearchEveryonePage():void
		{

			if (_searchEveryoneResultObject)
			{
				if (FacebookMobile.hasNext(_searchEveryoneResultObject))
				{
					FacebookMobile.nextPage(_searchEveryoneResultObject, handleSearchEveryone);
				}
			}

		}

		/*
		* Events GET_NEWSFEED_PHOTOS_SUCCESS, GET_NEWSFEED_PHOTOS_ERROR
		*/

		public function getNewsFeedPhotos():void
		{
			var query:String="SELECT attachment.media FROM stream WHERE filter_key = 'nf'";
			FacebookMobile.fqlQuery(query, handleGetNewsFeedPhotos);
		}

		/*
		* Events: GET_USER_DATA_SUCCESS,GET_USER_DATA_ERROR
		*/

		public function getUserData(id:String):void
		{
			FacebookMobile.api(id, handleGetUserData);
		}

		public function getGroupMembers(id:String):void
		{
			FacebookMobile.api(id + "/members", handleGetGroupMembers);
		}

		public function getEvents():void
		{
			FacebookMobile.api("me/events", handleEvents);
		}


		public function getSingleEvent(id:String):void
		{
			FacebookMobile.api(id, handleSingleEventResponse);
		}

		public function getEventInvitedList(id:String):void
		{
			FacebookMobile.api(id + "/invited", handleGetEventInvitedList);
		}


		/*
		* getPhotoAlbums()
		* Events: GET_ALBUMS_SUCCESS, GET_ALBUMS_ERROR
		*/


		public function getPhotoAlbums(id:String=null):void
		{
			if (id == null)
			{
				FacebookMobile.api('/me/albums', handleGetPhotoAlbumsResponse);
			}
			else
			{
				FacebookMobile.api(id + "/albums", handleGetPhotoAlbumsResponse);
			}
		}

		/*
		* getPhotosInAlbum()
		* Events: GET_PHOTOS_IN_ALBUM_SUCCESS, GET_PHOTOS_IN_ALBUM_ERROR
		*/

		public function getPhotosInAlbum(albumId:String):void
		{
			var params:Object=new Object();
			params.type="large";
			FacebookMobile.api("/" + albumId + "/photos", handleGetPhotosInAlbumResponse);
		}

		/*
		* getFriendsList()
		* Events: GET_FRIENDS_LIST_SUCCESS, GET_FRIENDS_LIST_ERROR
		*/

		public function getFriendsList():void
		{
			FacebookMobile.api('/me/friends', handleGetFriendsListResponse);
		}

		/*
		*  getNewsFeed()
		* Events: GET_NEWSFEED_SUCCESS, GET_NEWSFEED_ERROR
		*/

		public function getNewsFeed():void
		{
			FacebookMobile.api('/me/home', handleGetNewsFeedResponse);
		}

		/*
		*  searchNewsFeed()
		* Events: GET_NEWSFEED_SUCCESS, GET_NEWSFEED_ERROR
		*/

		public function searchNewsfeed(query:String, date:Date):void
		{
			var params:Object=new Object();

			if (!com.chewtinfoil.utils.StringUtils.isEmpty(query))
			{
				params.q=query;
			}

			if (date != null)
			{
				params.since=date;
			}

			FacebookMobile.api('/me/home', handleGetNewsFeedResponse, params);
		}

		/*
		* getMessages()
		* Events: GET_MESSAGES_SUCCESS, GET_MESSAGES_ERROR
		*/

		public function getMessages():void
		{
			FacebookMobile.api('/me/inbox', handleGetMessagesResponse);
		}

		/*
		* getWall()
		* Events: GET_WALL_SUCCESS, GET_WALL_ERROR
		*/

		public function getWall():void
		{
			FacebookMobile.api('/me/feed', handleGetWallResponse);
		}

		/*
		* getCheckins()
		* Events: GET_FRIENDS_CHECKINS_SUCCESS, GET_FRIENDS_CHECKINS_ERROR
		*/

		public function getCheckins():void
		{
			FacebookMobile.api("/search?type=checkin&", handleGetCheckinsResponse);
		}

		/*
		* getPlace()
		* Events: GET_PLACE_SUCCESS, GET_PLACE_ERROR
		*/

		public function getPlace(id:String):void
		{
			FacebookMobile.api("/" + id, handleGetPlaceResponse);
		}

		/*
		* Event: GET_LIKES_DATA_FOR_NEWSFEED_SUCCESS, GET_LIKES_DATA_FOR_NEWSFEED_ERROR
		*/
		public function getLikesForNewsFeedPost(id:String):Object
		{
			return newsFeedCache[id];
		}

		/*
		* Events: GET_GEOLOCATION_SUCCESS, GET_GEOLOCATION_ERROR, GEOLOCATION_NOT_SUPPORTED
		*/
		public function getGeolocation(updateInterval:int):void
		{

			if (Geolocation.isSupported)
			{
				_geoLocation=new Geolocation();

				if (_geoLocation.muted)
				{
					dispatchEvent(new Event(FBService.GEOLOCATION_ERROR_NOT_TURNED_ON));
				}

				_geoLocation.addEventListener(GeolocationEvent.UPDATE, handleLocationRequest);
				dispatchEvent(new Event(FBService.GEOLOCATION_IS_AVAILABLE));
			}
			else
			{
				dispatchEvent(new Event(FBService.GEOLOCATION_NOT_SUPPORTED));
			}
		}

		/*
		* getCloseLocations()
		*Events : GET_NEARBY_LOCATIONS_SUCCESS, GET_NEARBY_LOCATIONS_ERROR
		*/
		public function getCloseLocations(latitude:Number, longitude:Number, distance:int):void
		{
			var query:String="/search?type=place&center=" + String(latitude) + "," + String(longitude) + "&distance=" + String(distance) + "&";
			FacebookMobile.api(query, handleGetNearbyLocationsRequest);
		}



		public function postCheckin(placeId:String, name:String, latitude:Number, longitude:Number):void
		{
			var params:Object=new Object();
			params.name=name;
			params.place=placeId;
			params.coordinates='{"latitude"' + ':' + '"' + latitude.toString() + '"' + ',' + '"longitude"' + ':' + '"' + longitude.toString() + '"}';
			FacebookMobile.api("/me/checkins", handlePostCheckin, params, 'POST');
		}

		/*
		*submitComment()
		*Events: COMMENT_POST_SUCCESS, COMMENT_POST_ERROR
		*/

		public function submitComment(id:String, message:String):void
		{
			var values:URLVariables=new URLVariables();
			values.message=message;
			FacebookMobile.api('/' + id + '/comments', handleCommentPosted, values, 'POST');
		}


		public function getNotifications():void
		{
			trace(FacebookMobile.getSession().uid);
			FacebookMobile.api('/me/notifications', handleNotifications);
		}
		
		public function pollNotifications():void
		{
			trace(FacebookMobile.getSession().uid);
			FacebookMobile.api('/me/notifications', handleNotificationsPoll);
		}


		public function getNextNewsFeedPage():void
		{
			//separate query from url
			var url:String=_nextNewsFeedPage;
			
			if (url && url.indexOf("?") > -1)
			{
				var indexOfQuestionMark:int=url.indexOf("?");
				var query:String="";
				query=url.substr(indexOfQuestionMark + 1);
				//decode
				trace("query: " + query);
				var urlVars:URLVariables=new URLVariables();
				urlVars.decode(query);
				//build params object
				var params:Object=new Object();
				params["limit"]=25;
				params["until"]=urlVars.until;
				FacebookMobile.api('me/home', handleNewsFeed, params);
			}
		}

		public function getUserFeed(id:String):void
		{
			FacebookMobile.api(id + "/feed", handleGetNewsFeedResponse);
		}

		/*
		* getComments()
		* Events GET_COMMENTS_SUCCESS, GET_COMMENTS_ERROR
		* result saved in field: comments:ArrayCollection;
		* next page id saved in field: nextCommentsPage
		*/

		public function getComments(id:String):void
		{

			FacebookMobile.api(id + "/comments", handleCommentsResponse);
		}

		public function getNextCommentsPage(id:String):void
		{
			//separate query from url

			var url:String=_nextCommentsPage;
			var params:Object=new Object();
			trace("url: " + url);
			if (url == null)
			{
				FacebookMobile.api(id + "/comments", handleCommentsResponse, params);
			}
			else
			{
				var indexOfQuestionMark:int=url.indexOf("?");
				var query:String="";
				query=url.substr(indexOfQuestionMark + 1);
				//decode
				trace("query: " + query);
				var urlVars:URLVariables=new URLVariables();
				urlVars.decode(query);
				//build params object
				params["limit"]=urlVars.limit;
				params["offset"]=urlVars.offset;
				params["__after_id"]=urlVars.__after_id;
				FacebookMobile.api(id + "/comments", handleCommentsResponse, params);
			}
		}


		public function getGroups():void
		{
			FacebookMobile.api("me/groups", handleGroupsResponse);
		}
		
		/*
		* End public API
		*/
		
		private function handleGetSourceObject(success:Object,fail:Object):void{
			if(success){
				sourceObject = success;
				dispatchEvent(new Event(FBService.GET_SOURCE_OBJECT_SUCCESS));
			}else{
				dispatchEvent(new Event(FBService.GET_SOURCE_OBJECT_ERROR));
			}
		}

		private function handleGroupsResponse(success:Object, fail:Object):void
		{
			if (success)
			{

				var response:Array=success as Array;

				for (var i:uint=0; i < response.length; i++)
				{
					var vo:GroupVO=new GroupVO();
					vo.id=response[i].id;
					vo.icon=response[i].icon;
					vo.owner=response[i].owner;
					vo.name=response[i].name;
					vo.description=response[i].description;
					vo.link=response[i].link;
					vo.privacy=response[i].privacy;
					vo.updatedTime=response[i].updatedTime;
					groups.addItem(vo);
				}

				dispatchEvent(new Event(FBService.GET_GROUPS_SUCCESS));
			}
			else
			{
				dispatchEvent(new Event(FBService.GET_GROUPS_ERROR));
			}

		}

		
		private function handlePostToFeed(success:Object,fail:Object):void{
			if(success){
				trace("message was posted")
			}else{
				"message was not posted";
			}
		}


		private function handleGetNewsFeedPhotos(success:Object, fail:Object):void
		{
			if (success)
			{
				var response:Array=success as Array;
				for (var i:uint=0; i < response.length; i++)
				{
					if (response[i].attachment && response[i].attachment.media && response[i].attachment.media[0] && response[i].attachment.media[0].type == "photo")
					{
						var vo:Object=new Object();
						vo.id=response[i].attachment.media[0].photo.pid;
						vo.url=response[i].attachment.media[0].src;
						newsFeedPhotos.addItem(vo);
					}
				}
				dispatchEvent(new Event(FBService.GET_NEWSFEED_PHOTOS_SUCCESS));
			}
			else
			{
				dispatchEvent(new Event(FBService.GET_NEWSFEED_PHOTOS_ERROR));
			}
		}

		private function handleGetGroupMembers(success:Object, fail:Object):void
		{
			if (success)
			{
				var response:Array=success as Array;

				for (var i:uint=0; i < response.length; i++)
				{
					var vo:PersonVO=new PersonVO(response[i].id, response[i].name);
					groupMembers.addItem(vo);
					dispatchEvent(new Event(FBService.GET_GROUP_MEMBERS_SUCCESS));
				}
			}
			else
			{
				dispatchEvent(new Event(FBService.GET_GROUP_MEMBERS_ERROR));
			}
		}

		private function handleGetEventInvitedList(success:Object, fail:Object):void
		{
			
			
			
			if (success)
			{

				var response:Array=success as Array;
				
				for (var i:uint=0; i < response.length; i++)
				{
					var vo:InvitedPersonVO=new InvitedPersonVO();
					vo.name=response[i].name;
					vo.id=response[i].id;
					vo.rsvp=response[i].rsvp_status;
					invitedToEvent.addItem(vo);
				}

				dispatchEvent(new Event(FBService.GET_EVENT_INVITED_SUCCESS));
			}
			else
			{
				dispatchEvent(new Event(FBService.GET_EVENT_INVITED_ERROR));
			}
		}

		private function handleEvents(success:Object, fail:Object):void
		{

			if (success)
			{

				var response:Array=success as Array;

				for (var i:uint=0; i < response.length; i++)
				{

					var vo:EventVO=new EventVO();

					if (response[i].hasOwnProperty("name"))
					{
						vo.name=response[i].name;
					}
					if (response[i].hasOwnProperty("start_time"))
					{
						vo.startTime=response[i].start_time;
					}
					if (response[i].hasOwnProperty("end_time"))
					{
						vo.endTime=response[i].end_time;
					}
					if (response[i].hasOwnProperty("id"))
					{
						vo.id=response[i].id;
					}
					if (response[i].hasOwnProperty("rsvp_status"))
					{
						vo.rsvpStatus=response[i].rsvp_status;
					}
					events.addItem(vo);
				}
				dispatchEvent(new Event(FBService.GET_EVENTS_SUCCESS));

			}
			else
			{
				dispatchEvent(new Event(GET_EVENTS_ERROR));
			}
		}

		private function handleCommentsResponse(success:Object, fail:Object):void
		{



			if (success)
			{

				var raw:Object=FacebookMobile.getRawResult(success);
				var response:Object=raw.data;

				if (raw.paging && raw.paging.next)
				{
					_nextCommentsPage=raw.paging.next;
				}

				for (var i:uint=0; i < response.length; i++)
				{
					var item:CommentVO=new CommentVO();
					item.id=response[i].id;
					item.from.id=response[i].from.id;
					item.from.name=response[i].from.name;
					item.message=response[i].message;
					item.createdTime=response[i].created_time;
					item.likes=response[i].likes;
					item.type=response[i].type;
					item.userLikes=response[i].user_likes;
					comments.addItem(item);
				}

				dispatchEvent(new Event(FBService.GET_COMMENTS_SUCCESS));

			}
			else
			{
				dispatchEvent(new Event(FBService.GET_COMMENTS_ERROR));
			}
		}

		private function handleGetUserData(success:Object, fail:Object):void
		{

			if (success)
			{

				var friend:FriendVO=new FriendVO(success.name, success.id);

				if (success.hasOwnProperty("bio"))
				{
					friend.bio=success.bio;
				}

				if (success.hasOwnProperty("name"))
				{
					friend..name=success.name;
				}

				if (success.hasOwnProperty("relationship_status"))
				{
					friend.relationShipStatus=success.relationship_status;
				}

				if (success.hasOwnProperty("hometown"))
				{
					friend.homeTown=success.hometown.name;
					friend.homeTownId=success.hometown.id;
				}

				this.friend=friend;

				dispatchEvent(new Event(FBService.GET_USER_DATA_SUCCESS));
			}
			else
			{
				dispatchEvent(new Event(FBService.GET_USER_DATA_ERROR));
			}
		}



		private function handleNotifications(success:Object, fail:Object):void
		{
			if (success)
			{
				var response:Array=success as Array;

				if (response.length > 0)
				{
					for (var i:uint=0; i < response.length; i++)
					{
						var vo:NotificationVO=new NotificationVO(response[i].id);

						if (response[i].created_time)
						{
							vo.createdTimes=response[i].created_time
						}
						;
						if (response[i].from)
						{
							var from:PersonVO=new PersonVO();
							from.id=response[i].from.id;
							from.name=response[i].from.name;
							vo.from=from;
						}

						if (response[i].link)
						{
							vo.link=response[i].link;
						}
						if (response[i].title)
						{
							vo.title=response[i].title;
						}
						if (response[i].to)
						{
							var to:PersonVO=new PersonVO();
							to.id=response[i].to.id;
							to.name=response[i].to.name;
							vo.to=to;
						}
						if (response[i].unread)
						{
							vo.unread=response[i].unread;
						}
						if (response[i].updated_time)
						{
							vo.updatedTime=response[i].updated_time;
						}
						if (response[i].application)
						{
							vo.application=response[i].application;
						}
						notifications.addItem(vo);
					}
				}
				dispatchEvent(new Event(FBService.GET_NOTIFICATIONS_SUCCESS))
			}
			else
			{
				dispatchEvent(new Event(FBService.GET_NOTIFICATIONS_ERROR));
			}
		}
		
		private function handleNotificationsPoll(success:Object,fail:Object):void{
			if (success)
			{
				notifications.removeAll();
				
				var unfilteredResponse:Array=success as Array;
				
				if (unfilteredResponse.length > 0)
				{					
					notifications = buildNotificationsCollection(unfilteredResponse);
				}
				
				dispatchEvent(new Event(FBService.POLL_NOTIFICATIONS_SUCCESS))
			}
			else
			{
				dispatchEvent(new Event(FBService.POLL_NOTIFICATIONS_ERROR));
			}
		}
		
		private function buildNotificationsCollection(response:Array):ArrayCollection{
			
			var ac:ArrayCollection = new ArrayCollection();
			
			for (var i:uint=0; i < response.length; i++)
			{
				var vo:NotificationVO=new NotificationVO(response[i].id);
				
				if (response[i].created_time)
				{
					vo.createdTimes=response[i].created_time
				}
				;
				if (response[i].from)
				{
					var from:PersonVO=new PersonVO();
					from.id=response[i].from.id;
					from.name=response[i].from.name;
					vo.from=from;
				}
				
				if (response[i].link)
				{
					vo.link=response[i].link;
				}
				if (response[i].title)
				{
					vo.title=response[i].title;
				}
				if (response[i].to)
				{
					var to:PersonVO=new PersonVO();
					to.id=response[i].to.id;
					to.name=response[i].to.name;
					vo.to=to;
				}
				if (response[i].unread)
				{
					vo.unread=response[i].unread;
				}
				if (response[i].updated_time)
				{
					vo.updatedTime=response[i].updated_time;
				}
				if (response[i].application)
				{
					vo.application=response[i].application;
				}
				
				ac.addItem(vo);
			}
			
			return ac;
		}


		private function handleCommentPosted(success:Object, fail:Object):void
		{
			if (success)
			{
				dispatchEvent(new Event(FBService.COMMENT_POST_SUCCESS));
			}
			else
			{
				dispatchEvent(new Event(FBService.COMMENT_POST_ERROR));
			}


		}

		private function handlePostCheckin(success:Object, fail:Object):void
		{
			if(success){
				dispatchEvent(new Event(FBService.POST_CHECKIN_SUCCESS));
			}else{
				dispatchEvent(new Event(FBService.POST_CHECKIN_ERROR));	
			}


		}

		private function handleInit(success:Object, fail:Object):void
		{
			if (success)
			{
				_webView=null;
				dispatchEvent(new Event(FBService.INIT_SUCCESS));
			}
			else
			{

				dispatchEvent(new Event(FBService.INIT_ERROR));
			}
		}

		private function handleLogout(response:Object):void
		{
			_webView=null;

			dispatchEvent(new Event(FBService.LOGOUT_SUCCESS));
		}

		private function handleGetNearbyLocationsRequest(s:Object, fail:Object):void
		{

			if (s)
			{
				for (var i:int=0; i < s.length; i++)
				{
					var vo:PlaceVO=new PlaceVO();
					if (s[i].category)
						vo.category=s[i].category;
					if (s[i].id)
					{
						vo.id=s[i].id;
					}

					if (s[i].location)
					{
						if (s[i].city)
							vo.city=s[i].location.city;
						vo.latitude=s[i].location.latitude;
						trace(s[i].location.latitude);
						vo.longitude=s[i].location.longitude;
						if (s[i].name)
							vo.name=s[i].name;
					}
					nearbyLocations.addItem(vo);
				}
				dispatchEvent(new Event(FBService.GET_NEARBY_LOCATIONS_SUCCESS));
			}
			else
			{
				dispatchEvent(new Event(FBService.GET_NEWSFEED_ERROR));
			}
		}

		private function handleLocationRequest(event:GeolocationEvent):void
		{
			locationObject.latitude=event.latitude;
			locationObject.longitude=event.longitude;
			_geoLocation.removeEventListener(GeolocationEvent.UPDATE, handleLocationRequest);
			dispatchEvent(new Event(FBService.GET_GEOLOCATION_SUCCESS));
		}

		private function handleGetPlaceResponse(success:Object, fail:Object):void
		{
			if (success)
			{
				var vo:Object=new Object();
				vo.name=success.name;
				vo.picture=success.picture;
				vo.location=new Object();
				vo.location.city=success.location.city;
				vo.location.country=success.location.country;
				vo.location.latitude=success.location.latitude;
				vo.location.longitude=success.location.longitude;
				place=vo;
				this.dispatchEvent(new Event(FBService.GET_PLACE_SUCCESS));
			}
			else
			{
				this.dispatchEvent(new Event(FBService.GET_PLACE_ERROR));
			}
		}

		private function handleGetCheckinsResponse(success:Object, fail:Object):void
		{
			if (success)
			{
				var response:Array=success as Array;
				for (var i:int=0; i < response.length; i++)
				{
					var item:Object=new Object();
					item.from=new Object();
					item.from.id=response[i].from.id;
					item.from.name=response[i].from.name;
					item.message=response[i].message;
					item.place=new Object();
					item.place.id=response[i].place.id;
					item.place.name=response[i].place.name;
					item.place.location=new Object();
					item.place.location.city=response[i].place.location.city;
					item.place.location.country=response[i].place.location.country;
					checkinItems.addItem(item);

					this.dispatchEvent(new Event(FBService.GET_CHECKINS_SUCCESS));
				}
			}
			else
			{
				this.dispatchEvent(new Event(FBService.GET_CHECKINS_ERROR));
			}
		}


		private function handleGetWallResponse(success:Object, fail:Object):void
		{
			if (success)
			{
				var response:Array=success as Array;

				for (var i:int=0; i < response.length; i++)
				{
					var wallItem:Object=new Object();
					wallItem.from=new Object();
					wallItem.from.id=response[i].from.id;
					wallItem.from.name=response[i].from.name;
					wallItem.story=response[i].story;
					wallItems.addItem(wallItem);
				}

				this.dispatchEvent(new Event(FBService.GET_WALL_SUCCESS));

			}
			else
			{
				this.dispatchEvent(new Event(FBService.GET_WALL_ERROR));
			}
		}

		private function handleGetMessagesResponse(success:Object, fail:Object):void
		{
			if (success)
			{
				var response:Array=success as Array;

				for (var i:int=0; i < response.length; i++)
				{


					var message:Object=new Object();
					message.from=new Object();
					message.from.id=response[i].from.id;
					message.from.name=response[i].from.name;
					message.id=response[i].id;
					message.message=response[i].message;
					message.comments=response[i].comments;
					messages.addItem(message);
				}
				this.dispatchEvent(new Event(FBService.GET_MESSAGES_SUCCESS));
			}
			else
			{
				this.dispatchEvent(new Event(FBService.GET_MESSAGES_ERROR));
			}
		}

		private function handleGetNewsFeedResponse(success:Object, fail:Object):void
		{
			newsFeed.removeAll();
			if (success)
			{
				handleNewsFeed(success, null);
			}
		}

		private function handleNewsFeed(success:Object, fail:Object=null):void
		{

			if (success.length < 1)
			{
				dispatchEvent(new Event(FBService.NO_NEWSFEED_SEARCH_RESULTS_FOUND));
				return;
			}

			if (success)
			{

				var raw:Object=FacebookMobile.getRawResult(success);
				var response:Object=raw.data;

				if (raw.paging.next)
				{
					_nextNewsFeedPage=raw.paging.next;
				}

				for (var i:uint=0; i < response.length; i++)
				{
					var item:NewsFeedVO=new NewsFeedVO();

					if (response[i].id)
						item.id=response[i].id;
					if (response[i].from)
					{
						var from:PersonVO=new PersonVO();
						if (response[i].from.id)
							from.id=response[i].from.id;
						if (response[i].from.name)
							from.name=response[i].from.name;
						if (response[i].from.category)
							from.category=response[i].from.category;
						item.from=from;
					}
					if (response[i].link)
						item.link=response[i].link;
					if (response[i].name)
						item.name=response[i].name;
					if (response[i].message)
						item.message=response[i].message;
					if (response[i].caption)
						item.caption=response[i].caption;
					if (response[i].description)
						item.description=response[i].description;
					if (response[i].picture)
						item.picture=response[i].picture;
					if (response[i].icon)
						item.icon=response[i].icon;
					if (response[i].actions)
					{
						item.actions=new ActionsVO();
						item.actions.commentLink=response[i].actions[0].link;
						if (response[i].actions[1] != null && response[i].actions[1].hasOwnProperty("link"))
						{
							item.actions.likeLink=response[i].actions[1].link;
						}
					}
					if (response[i].type)
						item.type=response[i].type;
					if (response[i].created_time)
						item.created_time=response[i].created_time;
					if (response[i].updated_time)
						item.updated_time=response[i].updated_time;
					if (response[i].likes)
						item.likesCount=response[i].likes.count;
					if (response[i].comments)
					{
						item.commentsCount=response[i].comments.count;
						item.comments=response[i].comments;
					}
					if (response[i].story)
					{
						item.story=response[i].story;
					}
					if (response[i].story_tags)
					{

						item.storyTags=new Object();

						item.storyTags=response[i].story_tags;
					}
					if(response[i].place && response[i].place.id)
					{
						item.place.id = response[i].place.id;
					}
					newsFeed.addItem(item);
					newsFeedCache[item.id]=item;
				}

				getLikesForNewsFeed(item.id);
				this.dispatchEvent(new Event(FBService.GET_NEEWSFEED_SUCCESS));

			}
			else
			{
				this.dispatchEvent(new Event(FBService.GET_NEWSFEED_ERROR));
			}

		}

		private function getLikesForNewsFeed(post_id:String):void
		{
			var postIds:Array=[];
			for (var i:uint=0; i < newsFeed.length; i++)
			{
				postIds.push(newsFeed.getItemAt(i).id);
			}

			//Format a FQL query, using all the above id's.
			FacebookMobile.fqlQuery('SELECT likes, post_id FROM stream WHERE post_id IN ("' + postIds.join('", "') + '")', handleLikes);
		}

		private function handleLikes(success:Object, fail:Object):void
		{

			if (success)
			{
				var likes:Array=success as Array;

				if (likes != null)
				{
					for (var i:uint=0; i < likes.length; i++)
					{
						newsFeedCache[likes[i].post_id].likesCount=likes[i].likes.count;
						newsFeedCache[likes[i].post_id].userLikesIt=likes[i].likes.user_likes;
					}
				}
				EventCentral.getInstance().dispatchEvent(new Event(FBService.GET_LIKES_DATA_FOR_NEWSFEED_SUCCESS));
			}
			else
			{
				EventCentral.getInstance().dispatchEvent(new Event(FBService.GET_LIKES_DATA_FOR_NEWSFEED_ERROR));
			}
		}


		private function handleGetFriendsListResponse(success:Object, fail:Object):void
		{
			if (success)
			{
				friends.removeAll();
				var response:Array=success as Array;
				var friendsIds:Array=[];

				for (var i:int=0; i < response.length; i++)
				{
					var friend:FriendVO=new FriendVO(response[i].name, response[i].id);
					friends.addItem(friend);
				}

				this.dispatchEvent(new Event(FBService.GET_FRIENDS_LIST_SUCCESS));

			}
			else
			{
				this.dispatchEvent(new Event(FBService.GET_FRIENDS_LIST_ERROR))
			}
		}

		private function loginHandler(success:Object, fail:Object):void
		{
			if (success)
			{


				_webView=null;
				this.dispatchEvent(new Event(FBService.LOGIN_SUCCESS));
			}
			else
			{

				this.dispatchEvent(new Event(FBService.LOGIN_ERROR));
			}
		}

		private function handleGetPhotoAlbumsResponse(albums:Object, fail:Object):void
		{

			photoAlbums=[];

			if (albums != null)
			{
				var a:Array=new Array();
				a=albums as Array;
				for (var i:int=0; i < a.length; i++)
				{
					var vo:AlbumVO=new AlbumVO();
					vo.coverPhoto=a[i].cover_photo;
					vo.id=a[i].id;
					vo.name=a[i].name;
					vo.photos=a[i].photos;
					vo.link=a[i].link;
					vo.count=a[i].count;
					photoAlbums.push(vo);
				}
				this.dispatchEvent(new Event(FBService.GET_ALBUMS_SUCCESS));

			}
			else
			{
				this.dispatchEvent(new Event(FBService.GET_ALBUMS_ERROR));
			}
		}

		private function handleGetPhotosInAlbumResponse(photos:Object, fail:Object):void
		{
			if (photos != null)
			{

				photosInAlbum.removeAll();

				for (var i:int=0; i < (photos as Array).length; i++)
				{
					var vo:PhotoVO=new PhotoVO(photos[i].id);
					vo.name=photos[i].name;
					vo.thumbnailURL=photos[i].picture;
					vo.sourceXtraLarge=photos[i].images[0].source;
					vo.sourceLarge=photos[i].images[1].source;
					vo.sourceMedium=photos[i].images[2].source;
					vo.sourceSmall=photos[i].images[3].source;
					photosInAlbum.addItem(vo);
				}

				this.dispatchEvent(new Event(FBService.GET_PHOTOS_IN_ALBUM_SUCCESS));
			}
			else
			{
				this.dispatchEvent(new Event(FBService.GET_PHOTOS_IN_ALBUM_ERROR));
			}

		}

		private function handleSingleEventResponse(success:Object, fail:Object):void
		{
			if (success)
			{

				var vo:EventVO=new EventVO();
				vo.id=success.id;
				vo.owner.name=success.owner.name;
				vo.owner.id=success.owner.id;
				vo.name=success.name;
				vo.startTime=success.start_time;
				vo.endTime=success.end_time;
				vo.privacy=success.privacy;
				vo.type=success.type;

				singleEvent=vo;

				dispatchEvent(new Event(FBService.GET_SINGLE_EVENT_SUCCESS));
			}
			else
			{
				dispatchEvent(new Event(FBService.GET_SINGLE_EVENT_ERROR));
			}
		}

		private function handleSearchEveryone(success:Object, fail:Object):void
		{
			if (success)
			{

				_searchEveryoneResultObject=success;

				var raw:Object=FacebookMobile.getRawResult(success);

				var next:Object=FacebookMobile.hasNext(success);

				var response:Object=raw.data;

				if (raw.paging.next)
				{
					_nextSearchEveryonePage=raw.paging.next;
				}

				for (var i:uint=0; i < response.length; i++)
				{
					var friend:FriendVO=new FriendVO(response[i].name, response[i].id);
					friend.searchType="everyone";
					searchEveryoneResult.addItem(friend);
				}

				dispatchEvent(new Event(FBService.SEARCH_EVERYONE_SUCCESS));

			}
			else
			{

				dispatchEvent(new Event(FBService.SEARCH_EVERYONE_ERROR));

			}
		}


	}
}
