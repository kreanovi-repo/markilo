<?php


namespace App\Http\Responses\Api\v1;

class SuccessResponse
{
    public static function getSuccessResponse($status, $title, $description)
    {
        return response()->json([
            'success' => [
                'status' => $status,
                'title' => $title,
                'description' => $description
            ]
        ], intval($status));
    }
}
