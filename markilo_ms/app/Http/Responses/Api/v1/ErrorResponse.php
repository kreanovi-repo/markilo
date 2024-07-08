<?php

namespace App\Http\Responses\Api\v1;

use Illuminate\Http\Exceptions\HttpResponseException;

class ErrorResponse
{
    public static function getErrorResponse($status, $title, $description){
        return response()->json([
            'errors' => [
                'status' => $status,
                'title' => $title,
                'description' => $description
            ]
        ], intval($status));
    }

    public static function failedValidation($errorDescription){
        throw new HttpResponseException(
            self::getErrorResponse(
                '422',
                'Fails request validation',
                $errorDescription));
    }
}
