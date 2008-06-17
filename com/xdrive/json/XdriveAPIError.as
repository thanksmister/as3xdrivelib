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
	/**
	 * The XdriveAPIError class handles errors from Xdrive JSON API.
	 * 
	 * XdriveAPIError is the helper class for mapping error codes to more generic and user-friendly
	 * error messages.  
	 */
	public class XdriveAPIError
	{
		/** The requested service is temporarily unavailable.  */
		public static const INTERNAL_SERVER_ERROR:int = 0;
		
		/** The login details or auth token passed were invalid. */
		public static const INVALID_LOGIN_ERROR:int = 501;
		
		/** Generic database error, error in database call. */
		public static const GENERIC_DATABASE_ERROR:int = 100;
		
		/** User does not have permission to edit a folder. */
		public static const FOLDER_PERMISSION_ERROR:int = 364;
		
		/** Error occured during file upload */
		public static const UPLOAD_FILE_ERROR:int = 3302;	
		
		/** The user does not have permissioin to edit a show. */
		public static const SHOW_PERMISSION_ERROR:int = 352;
		
		/** The requested service is temporarily unavailable. */
		public static const EXEEDED_COPIES_ERROR:int = 379;
		
		/** The requested service is temporarily unavailable. */
		public static const HTTP_REQUEST_ERROR:int = 404;
		
		/** The method type was not supported. */
		public static const METHOD_NOT_SUPPORTED:int = 90001;
		
		/** JSON exception found on return call */
		public static var JSON_EXCECTPION : String = "exceptions";

		private var _errorCode:int;
		private var _errorMessage:String;
		
		public function XdriveAPIError() 
		{
		}
		
		/**
		 * Returns error message by errror number.
		 * 
		 * @param errorCode The number of the error code.
		 * @return String The error message.
		 **/
		public static function getErrorMessage(errorCode : Number) : String
		{
			//var errorCode:Number = Number(obj.exceptions[0].errorCode);
			
			switch (errorCode)
			{
				case XdriveAPIError.INVALID_LOGIN_ERROR:
					return "Login error, please verify your login and password.";
				
				case XdriveAPIError.GENERIC_DATABASE_ERROR:
					return "Unable to communicate to our database at this time. Please try again. If you continue to experience problems contact customer support for assistance.";

				case XdriveAPIError.INTERNAL_SERVER_ERROR:
					return "Internal Server Error. Please try this action again later. If you continue to experience problems contact customer support and provide this error message.";
						
				case XdriveAPIError.FOLDER_PERMISSION_ERROR:
					return "You do not have permission to create items in the selected folder.";
					
				case XdriveAPIError.SHOW_PERMISSION_ERROR:
					return "Only the owner of the show can rearrange the order or the photos and videos in a show.";
					
				case XdriveAPIError.UPLOAD_FILE_ERROR:
					return "Unable to upload your file. Please try again later.";
					
				case XdriveAPIError.EXEEDED_COPIES_ERROR:
					return "You can only have 11 copies of the same image in a given show.  Please remove some copies before saving."
				
				case XdriveAPIError.HTTP_REQUEST_ERROR:
					return "The server has not found a match for the requested URI."
				
				case XdriveAPIError.METHOD_NOT_SUPPORTED:
					return "The type value passed into the method was not supported."
					
				default:
					return "An error has occured, there is no additional information";
			}				

			return "An error has occured, there is no additional information";
		}
		
		public function get errorCode():int 
		{
			return _errorCode;	
		}
		
		public function set errorCode( value:int ):void 
		{
			_errorCode = value;	
		}
		
		public function get errorMessage():String 
		{
			return _errorMessage;	
		}
		
		public function set errorMessage( value:String ):void 
		{
			_errorMessage = value;	
		}
	}
}