<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::apiResource('user', App\Http\Controllers\Api\v1\Auth\UserController::class)->only(['index']);
    Route::post ('user/update/{id}', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'update']);
    Route::get ('user/is-authenticated', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'isAuthenticated']);
    Route::get ('user-by-uuid/{uuid}', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'showByUuid']);
    Route::get ('user-email-exists/{email}', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'emailExists']);
    Route::post('user/logout', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'logout']);
});

//API route for login user
Route::post('user/login',        [App\Http\Controllers\Api\v1\Auth\UserController::class, 'login']);
Route::post('user'      ,        [App\Http\Controllers\Api\v1\Auth\UserController::class, 'store']);
Route::post('user/delete/token/{token}', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'deleteToken']);
