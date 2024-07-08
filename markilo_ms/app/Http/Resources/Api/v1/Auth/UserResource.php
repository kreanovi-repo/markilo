<?php

namespace App\Http\Resources\Api\v1\Auth;

use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Str;

class UserResource extends JsonResource
{
    public static $wrap = null;

    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        $image = $this->resource->image;
        if(null != $this->resource->image){
            $image .= '?rnd=' . Str::random(5);
        }
        return  [
            'id'   => $this->resource->id,
            'uuid'   => $this->resource->uuid,
            'name' => $this->resource->name,
            'surname' => $this->resource->surname,
            'dni' => $this->resource->dni,
            'cell_phone' => $this->resource->cell_phone,
            'email' => $this->resource->email,
            'image' => $image,
            'background_color_voley' => $this->resource->background_color_voley,
            'voting_table' => $this->resource->voting_table,
            'role' => RoleResource::make($this->resource->role),
        ];
    }
}
