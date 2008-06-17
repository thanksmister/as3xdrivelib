/*
Copyright (C) 2008 AOL Xdrive

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Author: Michael Ritchie, Senior Flex Architect
        michael.ritchie@corp.aol.com
        
@ignore
*/

package com.xdrive.json
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * The XdriveAPIEvent class extends the flash.events.Event class.  
	 * <p>
	 * This event is broadcast with either a payload or error object upon the return of the JSON call. 
	 * Listen for the result or failure of this event to receive the response from the XdriveAPI method calls. 
	 * The XdriveAPIEvent event has modifies the Event class with additional parameters.
	 * </p>
	 * 
	 * * @example This example demonstrates how the event can be used properly.
	 * 
	 * <listing>
	 *    import com.xdrive.json.XdriveAPI;
	 *    import com.xdrive.json.XdriveAPIEvent;
	 *    import com.xdrive.json.XdriveAPIToken;
	 *    import com.xdrive.json.vo.User;
	 * 		
	 *    public function login():void
	 *    {
	 *        var service:XdriveAPI = new XdriveAPI();
	 *        var user:User = new User();
	 *            user.username = "username";
	 *            user.password = "password";
	 * 
	 *        var token:XdriveAPIToken = service.login(user);
	 *            token.addEventListener(XdriveAPIEvent.API_RESULT, result);
	 *            token.addEventListener(XdriveAPIEvent.API_FAILURE, fault);
	 *    }
	 * 
	 *    public function result( event : Object ) : void
	 *    {						
	 *        var resultEvent : XdriveAPIEvent = XdriveAPIEvent(event);
	 *        var user:User = resultEvent.payload.user as User;	
	 *        trace(user.firstname + "\n" + user.lastname);
	 *    }
	 * 
	 *    public function fault( event : Object ) : void 
	 *    {
	 *        var faultEvent : XdriveAPIEvent = XdriveAPIEvent( event );
	 *        trace(faultEvent.error.errorMessage + "\n" + faultEvent.error.errorCode); 
	 *    }
	 * </listing>
	 * */
	public class XdriveAPIEvent extends Event
	{
		/** XdriveAPIEvent type for API results */
		public static var API_RESULT : String = "API_RESULT";
		
		/** XdriveAPIEvent type for API failure */
		public static var API_FAILURE : String = "API_FAILURE";
		
		private var _payload : Object = null;
		private var _bytes : ByteArray = null;
		private var _error : XdriveAPIError = null;
		
		/**
		 * XdriveAPIEvent method for listening to the API result and failure events.
		 * 
		 * @param type <code>XdriveAPIEvent.API_RESULT</code> or <code>XdriveAPIEvent.API_FAILURE</code>
		 * @param payload Object containing the name of the object returned on the XdriveAPI method
		 * @param bytes ByteArray containing used from progress events such as upload and download, any time bytes are streamed
		 * @param error XdriveAPIError object containing error information on failure
		 * @param bubbles Boolean value for making the event bubble
		 */
		public function XdriveAPIEvent(type : String, payload : Object, bytes : ByteArray, error : XdriveAPIError, bubbles:Boolean = false) 
		{
			super(type);
			_payload = payload;
			_bytes = bytes;
			_error = error;
		}
		
		public function get payload() : Object 
		{
			return _payload;
		}
		
		public function get bytes() : ByteArray 
		{
			return _bytes;
		}
		
		public function get error() : XdriveAPIError 
		{
			return _error;
		}
	}
}