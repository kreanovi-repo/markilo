<?php

namespace App\Http\Controllers\Api\v1\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\v1\Auth\UserStoreRequest;
use App\Http\Requests\Api\v1\Auth\UserUpdateRequest;
use App\Http\Resources\Api\v1\Auth\UserCollection;
use App\Http\Resources\Api\v1\Auth\UserResource;
use App\Http\Responses\Api\v1\AuthResponse;
use App\Http\Responses\Api\v1\ErrorResponse;
use App\Http\Responses\Api\v1\SuccessResponse;
use App\Models\Api\v1\Auth\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

use function Symfony\Component\HttpFoundation\replace;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $users = User::all();
        return new UserCollection($users);
    }

    public function store(UserStoreRequest $request)
    {
        $user = User::create([
            'uuid' => Str::uuid(),
            'name' => $request['name'],
            'surname' => $request['surname'],
            'dni' => $request['dni'],
            'cell_phone' => $request['cell_phone'],
            'email' => $request['email'],
            'password' => $request['password'],
            'role_id' => $request['role_id'],
            'image' => 'data'. DIRECTORY_SEPARATOR . 'users'. DIRECTORY_SEPARATOR . 'images' . DIRECTORY_SEPARATOR . 'no-image.png'
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;
        return AuthResponse::getAuthResponse(200, new UserResource($user), $token);
    }

    public function login(Request $request)
    {
        if (!Auth::attempt($request->only('email', 'password')))
        {
            ErrorResponse::getErrorResponse(401, 'Unauthorized', 'Login faileddddd');
        }

        $user = User::where('email', $request['email'])->firstOrFail();
        if($user) {
            $tokenDB = DB::table('personal_access_tokens')->where('tokenable_id', $user->id)->first();
            if(!$tokenDB ) {
                if ($request['password'] == $user->password) {
                    $token = $user->createToken('auth_token')->plainTextToken;
                    return AuthResponse::getAuthResponse(200, new UserResource($user), $token);
                }
            }
            else{
                return AuthResponse::getAuthResponse(202, new UserResource($user), $tokenDB->token);
            }
        }
        return ErrorResponse::getErrorResponse(401, 'Unauthorized', 'Login failed');
    }

    public function logout()
    {
        auth()->user()->tokens()->delete();
        return SuccessResponse::getSuccessResponse(200, 'Logout success', 'You have successfully logged out and the token was successfully deleted');
    }

    public function deleteToken($token){
      DB::table('personal_access_tokens')->where('token', $token)->delete();
    }

    public function isAuthenticated(Request $request)
    {
        $token = str_replace("Bearer ", "", $request->header('Authorization'));
        return AuthResponse::getAuthResponse(200, new UserResource(auth()->user()), $token);
    }

    public function show(User $user)
    {
        return new UserResource($user);
    }

    public function update(UserUpdateRequest $request, $id)
    {
        $user = User::where('id', $id)->firstOrFail();
        if($user) {
            $user->update($request->validated());
            return new UserResource($user);
        }
    }

    public function showByUuid($uuid)
    {
        $user = User::where('uuid', $uuid)->firstOrFail();
        if($user) {
            return new UserResource($user);
        }

        return ErrorResponse::getErrorResponse(
            404,
            'Model not found',
            "No query results for model [App\\Models\\User] Uuid: {$uuid}");
    }

    public function emailExists($email)
    {
        $user = User::where('email', $email)->firstOrFail();
        if($user) {
            return new UserResource($user);
        }

        return ErrorResponse::getErrorResponse(
            404,
            'Model not found',
            "No query results for model [App\\Models\\User] Uuid: {$uuid}");
    }

    public function dniExists($dni)
    {
        $user = User::where('dni', $dni)->firstOrFail();
        if($user) {
            return new UserResource($user);
        }

        return ErrorResponse::getErrorResponse(
            404,
            'Model not found',
            "No query results for model [App\\Models\\User] Uuid: {$uuid}");
    }

    public function destroy(Request $request, User $user)
    {
        $user->delete();
        return SuccessResponse::getSuccessResponse(200, 'User deleted', 'User deleted successfully');
    }
}
