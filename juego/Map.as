package {
	
import flash.display.*;
import flash.geom.*;
import flash.filters.*;

public class Map {
  // Make the map into an island.  0.39 makes almost every map into an
  // island; 0.1 makes almost no map into an island.
  public static var ISLAND_EFFECT:Number = 0.39;
  
  public var SIZE:int;
  public var SEED:int;
  
  public var altitude:Vector.<Vector.<int>>;
  public var moisture:Vector.<Vector.<int>>;
  public var rivers:Vector.<Vector.<int>>;
  
  function Map(size:int, seed:int) {
    SIZE = size;
    SEED = seed;
    altitude = make2dArray(SIZE, SIZE);
    moisture = make2dArray(SIZE, SIZE);
    rivers =  make2dArray(SIZE, SIZE);
  }
  
  public function generate():void {
    // Generate 3-channel perlin noise and copy 2 of the channels out
    var b:BitmapData = new BitmapData(SIZE, SIZE);
    b.perlinNoise(SIZE, SIZE, 8, SEED, false, false);
	
	
    
    var s:Shape = new Shape();

    // NOTE: if we remembered the equalization and other parameters,
    // we could zoom in at least on the altitude map by using the
    // perlinNoise() size and offsets parameters to regenerate
    // portions of the map at higher resolution. This could be useful
    // when drawing the detail map.
	
    equalizeTerrain(b);

    // Overlay this on an "island" multiplier map
    // Based on http://www.ridgenet.net/~jslayton/FunWithWilburVol6/index.html
    for (x = 0; x < SIZE; x++) {
      for (y= 0; y < SIZE; y++) {
        var radiusSquared:Number = (x-SIZE/2)*(x-SIZE/2) + (y-SIZE/2)*(y-SIZE/2);
        radiusSquared += Math.pow(Math.max(Math.abs(x-SIZE/2), Math.abs(y-SIZE/2)), 2);
        var max_radiusSquared:Number = SIZE*SIZE/4;
        radiusSquared /= max_radiusSquared;
        radiusSquared += Math.random() * 0.1;
        radiusSquared *= ISLAND_EFFECT; 
        var island_multiplier:Number = Math.exp(-radiusSquared/4)-radiusSquared;
        island_multiplier = island_multiplier * island_multiplier * island_multiplier;
        // island_multiplier = island_multiplier * island_multiplier * island_multiplier;

        c = b.getPixel(x, y);
        var height:int = (c >> 8) & 0xff;
        height = int(island_multiplier * height);
        if (height < 0) height = 0;
        if (height > 255) height = 255;
        c = (c & 0xffff00ff) | (height << 8);
        b.setPixel(x, y, c);
      }
    }

    equalizeTerrain(b);
    
    // Extract information from bitmap
    for (var x:int = 0; x < SIZE; x++) {
      for (var y:int = 0; y < SIZE; y++) {
        var c:int = b.getPixel(x, y);
        altitude[x][y] = (c >> 8) & 0xff;
		//trace("altitud c = ", c, " *-* ", x, y, " = ", (c >> 8) & 0xff);
        moisture[x][y] = c & 0xff;
      }
    }
  }
  
  public function equalizeTerrain(bitmap:BitmapData):void {
    // Adjust altitude histogram so that it's roughly quadratic and
    // water histogram so that it's roughly linear
    var histograms:Vector.<Vector.<Number>> = bitmap.histogram(bitmap.rect);
    var G:Vector.<Number> = histograms[1];
    var B:Vector.<Number> = histograms[2];
    var g:int = 0;
    var b:int = 0;
    var green:Array = new Array(256);
    var blue:Array = new Array(256);
    var cumsumG:Number = 0.0;
    var cumsumB:Number = 0.0;
    for (var i:int = 0; i < 256; i++) {
      cumsumG += G[i];
      cumsumB += B[i];
      green[i] = (g*g/255) << 8; // int to green color value
      blue[i] = (b*b/255); // int to blue color value
      while (cumsumG > SIZE*SIZE*Math.sqrt(g/256.0) && g < 255) {
        g++;
      }
      while (cumsumB > SIZE*SIZE*(b/256.0) && b < 255) {
        b++;
      }
    }
    bitmap.paletteMap(bitmap, bitmap.rect, new Point(0, 0), null, green, blue, null);
    
    // Blur everything because the quadratic shift introduces
    // discreteness -- ick!!  TODO: probably better to apply the
    // histogram correction after we convert to the altitude[]
    // array, although even there it's already been discretized :(
    bitmap.applyFilter(bitmap, bitmap.rect, new Point(0, 0), new BlurFilter());

    // TODO: if we ever want to run equalizeTerrain after
    // spreadMoisture, we need to special-case water=255 (leave it alone)
  }
  
  public function make2dArray(w:int, h:int):Vector.<Vector.<int>> {
    var v:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(w);
    for (var x:int = 0; x < w; x++) {
      v[x] = new Vector.<int>(h);
      for (var y:int = 0; y < h; y++) {
        v[x][y] = 0;
      }
    }
    return v;
  }
  
  public function blurMoisture():void {
    // Note: this isn't scale-independent :(
    var radius:int = 1;
    var result:Vector.<Vector.<int>> = make2dArray(SIZE, SIZE);
    
    for (var x:int = 0; x < SIZE; x++) {
      for (var y:int = 0; y < SIZE; y++) {
        var numer:int = 0;
        var denom:int = 0;
        for (var dx:int = -radius; dx <= +radius; dx++) {
          for (var dy:int = -radius; dy <= +radius; dy++) {
            if (0 <= x+dx && x+dx < SIZE && 0 <= y+dy && y+dy < SIZE) {
              numer += moisture[x+dx][y+dy];
              denom += 1;
            }
          }
        }
        result[x][y] = numer / denom;
      }
    }
    moisture = result;
  }
  
  public function spreadMoisture():void {
    var windX:Number = SIZE/17.0;
    var windY:Number = SIZE/23.0;
    var evaporation:int = 1;
    
    var result:Vector.<Vector.<int>> = make2dArray(SIZE, SIZE);
    for (var x:int = 0; x < SIZE; x++) {
      for (var y:int = 0; y < SIZE; y++) {
        if (altitude[x][y] < mapgen.OCEAN_ALTITUDE) {
          result[x][y] += 255; // ocean
        }
        
        result[x][y] += moisture[x][y] - evaporation;

        // Dampen the randomness
        var wx:Number = (20.0 + Math.random() + Math.random()) / 21.0;
        var wy:Number = (20.0 + Math.random() + Math.random()) / 21.0;
        var x2:int = x + int(windX * wx);
        var y2:int = y + int(windY * wy);
        x2 %= SIZE; y2 %= SIZE;
        if (x != x2 && y != y2) {
          var transfer:int = moisture[x][y]/3;
          var speed:Number = (30.0 + altitude[x][y]) / (30.0 + altitude[x2][y2]);
          if (speed > 1.0) speed = 1.0;
          /* speed is lower if going uphill */
          transfer = int(transfer * speed);
          
          result[x][y] -= transfer;
          result[x2][y2] += transfer;
        }
      }
    }

    for (x = 0; x < SIZE; x++) {
      for (y = 0; y < SIZE; y++) {
        if (result[x][y] < 0) result[x][y] = 0;
        if (result[x][y] > 255) result[x][y] = 255;
      }
    }
    
    moisture = result;
  }

  public function carveCanyons():void {
    for (var iteration:int = 0; iteration < 10000; iteration++) {
      var x:int = int(Math.floor(SIZE*Math.random()));
      var y:int = int(Math.floor(SIZE*Math.random()));

      for (var trail:int = 0; trail < 1000; trail++) {
        // Just quit at the boundaries
        if (x == 0 || x == SIZE-1 || y == 0 || y == SIZE-1) {
          break;
        }

        // Find the minimum neighbor
        var x2:int = x, y2:int = y;
        for (var dx:int = -1; dx <= +1; dx++) {
          for (var dy:int = -1; dy <= +1; dy++) {
            if (altitude[x+dx][y+dy] < altitude[x2][y2]) {
              x2 = x+dx; y2 = y+dy;
            }
          }
        }

        // TODO: make the river keep going to the ocean no matter what!
        
        // Move the particle in that direction, and remove some land
        if (x == x2 && y == y2) {
          if (altitude[x][y] < 10) break;
          // altitude[x][y] = Math.min(255, altitude[x][y] + trail);
        }
        x = x2; y = y2;
        altitude[x][y] = Math.max(0, altitude[x][y] - 1);
        rivers[x][y] += 1;
      }
    }

    for (x = 0; x < SIZE; x++) {
      for (y = 0; y < SIZE; y++) {
        if (rivers[x][y] > 100) moisture[x][y] = 255;
      }
    }
  }
}

}

