package  
{
	public class Vector2D 
	{
		public var x:Number;
		public var y:Number;
		
		public function Vector2D(_x:Number = 0, _y:Number = 0) 
		{
			x = _x;
			y = _y;
		}
		
		public function Equals(_vector2:Vector2D) : Boolean 
		{
			return (x == _vector2.x && y == _vector2.y);
		}
		
		public function GetLength() : Number
		{
			return Math.sqrt((x * x) + (y * y));
		}
		
		public function GetAngle() : Number
		{
			return Math.atan2(y, x);
		}
		
		public function Normalize()
		{
			if (GetLength() == 0)
			{
				x = 1;
				return this;
			}
			
			x /= GetLength();
			y /= GetLength();
			
		}
		
		public function GetDistance(_vector2:Vector2D) : Number
		{
			var dX:Number = _vector2.x - x;
			var dY:Number = _vector2.y - y;
			
			return Math.sqrt((dX * dX) + (dY * dY));
		}
		
	}

}