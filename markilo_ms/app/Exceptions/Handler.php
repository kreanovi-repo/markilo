<?php

namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use App\Http\Responses\Api\v1\ErrorResponse;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

use Throwable;

class Handler extends ExceptionHandler
{
    /**
     * The list of the inputs that are never flashed to the session on validation exceptions.
     *
     * @var array<int, string>
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * Register the exception handling callbacks for the application.
     */
    public function register(): void
    {
        $this->reportable(function (Throwable $e) {
            //
        });
    }

    public function render($request, Throwable $exception)
  {
      if( $request->is('api/*')){
          if ($exception instanceof ModelNotFoundException) {
              $model = strtolower(class_basename($exception->getModel()));
              return ErrorResponse::getErrorResponse('404', 'Model not found', $exception->getMessage());

          }
          if ($exception instanceof NotFoundHttpException) {
              return ErrorResponse::getErrorResponse('404', 'Source not found', $exception->getMessage());
          }

          if("Route [login] not defined." == $exception->getMessage()) {
              return ErrorResponse::getErrorResponse('401', 'Unauthorized', 'The user is not logged in');
          }

          if("Integrity constraint violation" == $exception->getMessage()) {
              return ErrorResponse::getErrorResponse('503', 'Internal server error', $exception->getMessage());
          }

          return ErrorResponse::getErrorResponse('406', 'Not Acceptable', $exception->getMessage());
      }
  }

  private function getResponseException($title, $detail){
      return response()->json([
          'errors' => [
              'status' => '404',
              'source' => '',
              'title' => $title,
              'detail' => $detail
          ]
      ], 404);
  }

}
