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

package com.xdrive.json.utils
{
	public class DateUtils
	{
		/**
	 	* Date utitlies constructor
	 	*/
		public function DateUtils()
		{
		}
		
		/** 
		 * Converts a string to Date object.
		 * 
		 * @param str The String value of the date
		 * @return Date
		 * */
		public static function formatDate( str:String = "" ):Date 
		{
			if ( str == ""  || undefined ) return null;
			
		    var date:Date = new Date();
				date.setTime( parseInt( str ));
		
			return date;
		}
	}
}