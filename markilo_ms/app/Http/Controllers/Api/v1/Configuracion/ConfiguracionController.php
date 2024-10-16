<?php

namespace App\Http\Controllers\Api\v1\Configuracion;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\v1\Configuracion\ConfiguracionStoreRequest;
use App\Http\Requests\Api\v1\Configuracion\ConfiguracionUpdateRequest;
use App\Http\Resources\Api\v1\Configuracion\ConfiguracionCollection;
use App\Http\Resources\Api\v1\Configuracion\ConfiguracionResource;
use App\Models\Api\v1\Configuracion\Configuracion;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class ConfiguracionController extends Controller
{
    public function index(Request $request)
    {
        $configuracions = Configuracion::all();

        return new ConfiguracionCollection($configuracions);
    }

    public function store(ConfiguracionStoreRequest $request)
    {
        $configuracion = Configuracion::create($request->validated());

        return new ConfiguracionResource($configuracion);
    }

    public function show(Request $request, $idconfiguracion)
    {
        $configuracion = Configuracion::where('id', $idconfiguracion)->firstOrFail();
        if($configuracion) {
            return new ConfiguracionResource($configuracion);
        }
    }

    public function update(ConfiguracionUpdateRequest $request, Configuracion $configuracion)
    {
        $configuracion->update($request->validated());

        return new ConfiguracionResource($configuracion);
    }

    public function destroy(Request $request, Configuracion $configuracion)
    {
        $configuracion->delete();

        return response()->noContent();
    }
}
