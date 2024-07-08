<?php


namespace App\Http\Responses\Api\v1;

use App\Http\Resources\Api\v1\Auth\UserResource;

class AuthResponse
{
    public static function getAuthResponse($status, $user, $token)
    {
        return response()
            ->json([
                'user' => new UserResource($user),
                'access_token' => $token,
                'token_type' => 'Bearer'
            ], $status);
    }
}
