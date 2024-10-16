<?php

namespace App\Http\Requests\Api\v1\Auth;

use App\Http\Responses\Api\v1\ErrorResponse;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;

class UserUpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'name' => ['required', 'string'],
            'surname' => ['required', 'string'],
            'dni' => ['required', 'numeric'],
            'cell_phone' => ['required', 'string'],
            'email' => ['required', 'email'],
            'image' => ['string'],
            'app_version' => ['required', 'string'],
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        ErrorResponse::failedValidation($validator->errors()->first());
    }
}
