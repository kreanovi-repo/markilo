<?php

namespace App\Http\Resources\Api\v1\Configuracion;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ConfiguracionResource extends JsonResource
{
    public static $wrap = null;

    protected $table = 'configuracion';

    /**
     * Transform the resource into an array.
     */
    public function toArray(Request $request)
    {
        return [
            'id' => $this->id,
            'app_version' => $this->app_version,
            'build_date' => $this->build_date,
            'hash' => $this->hash,
        ];
    }
}
