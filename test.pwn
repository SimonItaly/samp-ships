#include <a_samp>
#include "samp-ships"

static
    route_forward,
    route_backwards;

stock Float:array_reverse(const Float:list[][2], size)
{
	new
		pos,
		len = size-1,
		Float:result[64][2];

	while ( (len >= 0 && pos < sizeof(result)) &&
          ( (result[pos][0] = list[len][0]) && (result[pos][1] = list[len][1]) ) )
    {
        pos++;
        --len;
    }

	return result;
}

public OnFilterScriptInit()
{
    new ship_id = CreateShip(-3279.01855, -3034.28296, 7.33, 0.0);

    SetShipBodyMaterial(ship_id, 10789, "xenon_sfse", "bluemetal02", 0xFFFFFFFF);

    SetShipContainerMaterial(ship_id, CONTAINER_RED, 10230, "freight_sfe", "frate64_blue",
                                         8883, "vgsefreight", "frate_doors64128");

    SetShipContainerMaterial(ship_id, CONTAINER_BLUE, 10230, "freight_sfe", "frate64_blue",
                                         8883, "vgsefreight", "frate_doors64128");

    SetShipContainerMaterial(ship_id, CONTAINER_YELLOW, 10230, "freight_sfe", "frate64_blue",
                                         8883, "vgsefreight", "frate_doors64128");

    new const Float:route[][2] =
    {
        {-3279.01855, -3034.28296},
        {-3325.52783, 1171.91589},
        {-2982.63477, 1687.91125},
        {-1907.10254, 1776.17517},
        {-1340.10999, 1364.19568},
        {-1342.35938, 869.20868},
        {-1211.62256, 638.47266},
        {-990.97693, 602.15613},
        {-1431.59937, 191.26247}
    };
    
    //Route 1
    route_forward = CreateRoute(route, sizeof(route));

    //Route 2 = reverse of route 1
    route_backwards = CreateRoute(array_reverse(route, sizeof(route)), sizeof(route));

    StartRouteForShip(route_forward, ship_id);
}

public OnShipRouteCompleted(ship_id, route_id, steps)
{
    printf("\nShip %d finished route %d in %d steps\n",
                    ship_id, route_id, steps);

    if(route_id == route_forward)
    {
		StartRouteForShip(route_backwards, ship_id);
	}
	else if(route_id == route_backwards)
	{
		StartRouteForShip(route_forward, ship_id);
	}
    return 1;
}
