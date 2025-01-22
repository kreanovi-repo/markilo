<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group(['middleware' => ['auth:sanctum']], function () {

    Route::apiResource('user', App\Http\Controllers\Api\v1\Auth\UserController::class)->only(['index']);
    // Routes personalized
    Route::get ('user/is-authenticated', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'isAuthenticated']);
    Route::get ('user-by-uuid/{uuid}', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'showByUuid']);
    Route::post('user/logout', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'logout']);
    Route::post('user/upload-image/{uuid}', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'uploadImage']);
    Route::post ('user/update/{id}', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'update']);

    Route::apiResource('role', App\Http\Controllers\Api\v1\Auth\RoleController::class)->only(['index']);

    Route::apiResource('file', App\Http\Controllers\Api\v1\Files\FileController::class)->only(['show', 'store']);
    Route::post('file/upload-file', [App\Http\Controllers\Api\v1\Helper\File\FileHelperController::class, 'uploadFile']);
    Route::delete('file/delete-file', [App\Http\Controllers\Api\v1\Helper\File\FileHelperController::class, 'deleteFile']);

    Route::apiResource('general/crop-specie', App\Http\Controllers\Api\v1\General\Crop\CropSpecieController::class)->except('update');
    Route::post ('general/crop-specie/{id}', [App\Http\Controllers\Api\v1\General\Crop\CropSpecieController::class, 'update']);

    Route::apiResource('general/crop-variety', App\Http\Controllers\Api\v1\General\Crop\CropVarietyController::class)->except('update');
    Route::post ('general/crop-variety/{id}', [App\Http\Controllers\Api\v1\General\Crop\CropVarietyController::class, 'update']);

    Route::apiResource('general/hotbed', App\Http\Controllers\Api\v1\General\Hotbed\HotbedController::class);

    Route::apiResource('driver', App\Http\Controllers\Api\v1\Logistic\DriverController::class);

    Route::apiResource('general/client', App\Http\Controllers\Api\v1\Client\ClientController::class);

    Route::apiResource('producer', App\Http\Controllers\Api\v1\Producer\ProducerController::class);

    Route::apiResource('silo', App\Http\Controllers\Api\v1\Storage\Silo\SiloController::class);
    Route::post('silo/increment-capacity', [App\Http\Controllers\Api\v1\Storage\Silo\SiloController::class, 'incrementCapacity']);
    Route::post('silo/decrement-capacity', [App\Http\Controllers\Api\v1\Storage\Silo\SiloController::class, 'decrementCapacity']);

    Route::apiResource('seed-income', App\Http\Controllers\Api\v1\Storage\Seed\SeedIncomeController::class)->except('update');
    Route::post ('seed-income/{id}', [App\Http\Controllers\Api\v1\Storage\Seed\SeedIncomeController::class, 'update']);
    Route::get ('seed-income-by-uuid/{uuid}', [App\Http\Controllers\Api\v1\Storage\Seed\SeedIncomeController::class, 'showByUuid']);
    Route::get ('seed-income-by-silo/{siloId}', [App\Http\Controllers\Api\v1\Storage\Seed\SeedIncomeController::class, 'indexBySilo']);
    Route::post('seed-income-analysis', [App\Http\Controllers\Api\v1\Storage\Seed\SeedIncomeController::class, 'createSeedIncomeAnalysisRelation']);
    Route::post('seed-income-classification', [App\Http\Controllers\Api\v1\Storage\Seed\SeedIncomeController::class, 'createSeedIncomeClassificationRelation']);

    Route::apiResource('analysis-type', App\Http\Controllers\Api\v1\Analysis\AnalysisTypeController::class);

    Route::apiResource('analysis', App\Http\Controllers\Api\v1\Analysis\AnalysisController::class)->except('update');
    Route::post ('analysis/{id}', [App\Http\Controllers\Api\v1\Analysis\AnalysisController::class, 'update']);

    Route::apiResource('analysis-sample-code', App\Http\Controllers\Api\v1\Analysis\AnalysisSampleCodeController::class)->except('update');
    Route::post ('analysis-sample-code/{id}', [App\Http\Controllers\Api\v1\Analysis\AnalysisSampleCodeController::class, 'update']);
    Route::post ('analysis-sample-code/generate/qr', [App\Http\Controllers\Api\v1\Analysis\AnalysisSampleCodeController::class, 'generateQrSampleLaboratory']);

    Route::apiResource('deposit', App\Http\Controllers\Api\v1\Storage\Deposit\DepositController::class);
    Route::post ('deposit/classifications', [App\Http\Controllers\Api\v1\Storage\Deposit\DepositController::class, 'getClassifications']);

    Route::apiResource('category', App\Http\Controllers\Api\v1\Category\CategoryController::class);

    Route::apiResource('classification', App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class)->except('update');
    Route::post ('classification/{id}', [App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class, 'update']);
    Route::get ('classification/availability', [App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class, 'indexByAvailability']);
    Route::get ('classification/uuid/{uuid}', [App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class, 'showByUuid']);
    Route::post ('classification/generate/qr', [App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class, 'generateQrIdentification']);
    Route::post('classification-analysis', [App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class, 'createClassificationAnalysisRelation']);
    Route::post ('classification/data/import/excel', [App\Http\Controllers\Api\v1\ImportData\ImportClassificationsFromExcelController::class, 'import']);
    Route::post('classification/label/generate', [App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class, 'generateLabel']);

    Route::get ('classifications-viewed', [App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class, 'getClassificationsViewed']);

    Route::apiResource('province', App\Http\Controllers\Api\v1\Province\ProvinceController::class);

    Route::apiResource('city', App\Http\Controllers\Api\v1\City\CityController::class);
    Route::get ('city/import/excel', [App\Http\Controllers\Api\v1\City\CityController::class, 'import']);

    Route::apiResource('dispatch', App\Http\Controllers\Api\v1\Dispatch\DispatchController::class);

    Route::apiResource('receipt', App\Http\Controllers\Api\v1\Receipt\ReceiptController::class);
    Route::get ('receipt/traceability/{id}', [App\Http\Controllers\Api\v1\Receipt\ReceiptController::class, 'getReceiptTraceability']);
    Route::post ('receipt/generate/pdf', [App\Http\Controllers\Api\v1\Receipt\ReceiptController::class, 'generateReceiptPdf']);
    Route::post ('receipt/receipt/create/relation', [App\Http\Controllers\Api\v1\Receipt\ReceiptController::class, 'createReceiptReceiptRelation']);
    Route::post ('receipt/receipt/delete/relation', [App\Http\Controllers\Api\v1\Receipt\ReceiptController::class, 'deleteReceiptReceiptRelation']);
    Route::post ('receipt/receipt-document/create/relation', [App\Http\Controllers\Api\v1\Receipt\ReceiptController::class, 'createReceiptReceiptDocumentRelation']);
    Route::post ('receipt/receipt-document/delete/relation', [App\Http\Controllers\Api\v1\Receipt\ReceiptController::class, 'deleteReceiptReceiptDocumentRelation']);
    Route::post ('receipt/receipt-detail/create/relation', [App\Http\Controllers\Api\v1\Receipt\ReceiptController::class, 'createReceiptReceiptDetailRelation']);
    Route::post ('receipt/receipt-detail/delete/relation', [App\Http\Controllers\Api\v1\Receipt\ReceiptController::class, 'deleteReceiptReceiptDetailRelation']);

    Route::apiResource('receipt-type', App\Http\Controllers\Api\v1\Receipt\ReceiptTypeController::class);

    Route::apiResource('receipt-detail', App\Http\Controllers\Api\v1\Receipt\ReceiptDetailController::class);

    Route::apiResource('receipt-document', App\Http\Controllers\Api\v1\Receipt\ReceiptDocumentController::class);
    Route::apiResource('receipt-document-type', App\Http\Controllers\Api\v1\Receipt\ReceiptDocumenTypeController::class);

    Route::apiResource('product', App\Http\Controllers\Api\v1\Product\ProductController::class);

    /* Tce */
    Route::get ('configuration/tce/{id}', [App\Http\Controllers\Api\v1\General\Configuration\Tce\ConfigurationTceController::class, 'show']);
    Route::get ('configuration/tce', [App\Http\Controllers\Api\v1\General\Configuration\Tce\ConfigurationTceController::class, 'showLatest']);
});


//API route for login user
Route::post('user/login', [App\Http\Controllers\Api\v1\Auth\UserController::class, 'login']);
Route::post('user'      , [App\Http\Controllers\Api\v1\Auth\UserController::class, 'store']);

Route::apiResource('receipt-documen-type', App\Http\Controllers\Api\v1\Receipt\ReceiptDocumenTypeController::class);

Route::apiResource('audit-record', App\Http\Controllers\Api\v1\Audit\AuditRecordController::class);

Route::apiResource('treatment', App\Http\Controllers\Api\v1\General\Treatment\TreatmentController::class);

Route::apiResource('treatment-type', App\Http\Controllers\Api\v1\General\Treatment\TreatmentTypeController::class);

Route::get ('classification/lot/number/{lot_number}', [App\Http\Controllers\Api\v1\Classification\Classification\ClassificationController::class, 'showByLotNumber']);

