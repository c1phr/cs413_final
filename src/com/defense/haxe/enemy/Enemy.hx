import com.cykon.haxe.movable.circle.Circle;
import com.cykon.haxe.cmath.Vector;
import com.cykon.haxe.movable.Point;

class Enemy extends Circle{
	private var pointArray:Array<Point>;

	public function new(){
		super();
	}

	public override function applyVelocity(modifier:Float):Bool{
		super.applyVelocity(modifier);
		var velocityVector = new Vector(vx, vy);
		var pointVector = Vector.getVector(x,y,pointx,pointy);
		if (velocityVector.dot(pointVector) < 0){
			x = pointx;
			y = pointy;

			velocityVector.getMag()
		}

	}
}