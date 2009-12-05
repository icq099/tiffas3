// DragPanel, by Narciso Jaramillo, nj_flex@rictus.com
// Copyright 2006 Narciso Jaramillo

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

package com.rictus.dragpanel
{
	import mx.containers.Panel;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * A version of Panel that you can drag around by its header.  (The standard
	 * Panel class can only be dragged when it's popped up by the PopUpManager.)
	 * 
	 * Author: Narciso Jaramillo, nj_flex@rictus.com
	 */
	public class DragPanel extends Panel
	{
		private var _startX: Number;
		private var _startY: Number;
		private var _dragStartX: Number;
		private var _dragStartY: Number;
		private var _isDragging: Boolean = false;
		
		override public function initialize(): void {
			super.initialize();
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		}
		
		private function handleMouseDown(event: MouseEvent): void {
			var contentPoint: Point = globalToContent(new Point(event.stageX, event.stageY));
			if (contentPoint.y < 0) {
				// While the mouse event is down, we need to capture all move/up events, even
				// if we aren't the target (since the mouse will often move outside of our
				// current bounds).  To do this, we register these listeners with the top-level 
				// SystemManager, and set useCapture to true to get first crack at the events.
				// This is essentially equivalent to the old setCapture() method.
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, true);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, true);

				_startX = x;
				_startY = y;
				_dragStartX = event.stageX;
				_dragStartY = event.stageY;
				
				// Clear any constraints that might have been set, so we can move around freely.
				clearStyle("left");
				clearStyle("right");
				clearStyle("top");
				clearStyle("bottom");
				clearStyle("horizontalCenter");
				clearStyle("verticalCenter");
				
				_isDragging = true;
			}
		}
		
		private function handleMouseMove(event: MouseEvent): void {
			if (_isDragging) {
				// Don't allow the actual target of the event to handle it.
				event.stopImmediatePropagation();
				move(_startX + event.stageX - _dragStartX, _startY + event.stageY - _dragStartY);
			}
		}

		private function handleMouseUp(event: MouseEvent): void {
			if (_isDragging) {
				// Don't allow the actual target of the event to handle it.
				event.stopImmediatePropagation();
				move(_startX + event.stageX - _dragStartX, _startY + event.stageY - _dragStartY);
				systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, true);
				systemManager.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp, true);
				_isDragging = false;
			}
		}
	}
}