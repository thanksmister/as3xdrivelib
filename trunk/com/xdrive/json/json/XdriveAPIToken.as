/*
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
        michael.ritchie@gmail.com
*/
package com.xdrive.json
{
	import mx.messaging.messages.IMessage;
	import mx.rpc.AsyncToken;
	
	/**
	 *  This class extends mx.rpc.AsyncToken provides a place to set additional or token-level data for 
	 *  asynchronous RPC operations.  It also allows an IResponder to be attached for an individual call.
	 *  
	 * The XdriveAPIToken can be referenced in <code>ResultEvent</code> and 
	 *  <code>FaultEvent</code> from the <code>token</code> property.
	 * 
	 * XdriveAPIToken returns a the name of the object passed into the XdriveAPI methods.  Similar to the 
	 * payload on the XDriveAPIEvent, the object name will be the same as the return value of the method
	 * call.  
	 * 
	 * @example This example demonstrates how the token can be used properly.
	 * 
	 * <listing>
	 *    import com.xdrive.json.XdriveAPI;
	 *    import com.xdrive.json.XdriveAPIEvent;
	 *    import com.xdrive.json.XdriveAPIToken;
	 *    import com.xdrive.json.vo.User;
	 * 		
	 *    private var token:XdriveAPIToken;		
	 * 
	 *    public function login():void
	 *    {
	 *        var service:XdriveAPI = new XdriveAPI();
	 *        var user:User = new User();
	 *            user.username = "username";
	 *            user.password = "password";
	 * 
	 *        token = service.login(user);
	 *        token.addEventListener(XdriveAPIEvent.API_RESULT, result);
	 *        token.addEventListener(XdriveAPIEvent.API_FAILURE, fault);
	 *    }
	 * 
	 *    public function result( event : Object ) : void
	 *    {						
	 *        var resultEvent : XdriveAPIEvent = XdriveAPIEvent(event);
	 *        var user:User = token.user as User;	
	 *        trace(user.firstname + "\n" + user.lastname);
	 *    }
	 * 
	 *    public function fault( event : Object ) : void 
	 *    {
	 *        var faultEvent : XdriveAPIEvent = XdriveAPIEvent( event );
	 *        trace(faultEvent.error.errorMessage + "\n" + faultEvent.error.errorCode); 
	 *    }
	 * </listing>
	 */
	public dynamic class XdriveAPIToken extends AsyncToken
	{
		public function XdriveAPIToken(message : IMessage) {
			super(message);
		}
	}
	
}