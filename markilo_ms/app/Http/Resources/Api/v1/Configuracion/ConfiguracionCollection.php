<?php

namespace App\Http\Resources\Api\v1\Configuracion;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class ConfiguracionCollection extends ResourceCollection
{
    public static $wrap = null;

    /**
     * Transform the resource collection into an array.
     */
    public function toArray(Request $request): array
    {
        return [
            'Configuraciones' => $this->collection,
        ];
    }
}
