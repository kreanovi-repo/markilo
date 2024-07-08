<?php

namespace App\Http\Controllers\Api\v1\Auth;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\v1\Auth\RoleCollection;
use App\Models\Api\v1\Auth\Role;
use Illuminate\Http\Request;

use function Symfony\Component\HttpFoundation\replace;

class RoleController extends Controller
{
    /**
     * @param \Illuminate\Http\Request $request
     * @return \App\Http\Resources\Api\UserCollection
     */
    public function index(Request $request)
    {
        $roles = Role::all();
        return new RoleCollection($roles);
    }
}
