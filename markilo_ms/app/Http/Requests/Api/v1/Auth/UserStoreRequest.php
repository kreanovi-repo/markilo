<?php

namespace App\Http\Requests\Api\v1\Auth;

use App\Http\Responses\Api\v1\ErrorResponse;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;

class UserStoreRequest extends FormRequest
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
            'email' => ['required', 'email'],
            'dni' => ['required', 'numeric'],
            'cell_phone' => ['required', 'string'],
            'password' => [
                            'required',
                            'string',
                            'min:8',             // must be at least 10 characters in length
                            /*'regex:/[a-z]/',      // must contain at least one lowercase letter
                            'regex:/[A-Z]/',      // must contain at least one uppercase letter
                            'regex:/[0-9]/',      // must contain at least one digit
                            'regex:/[@$!%*#?&]/'*/],
            'role_id' => ['required', 'integer']
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        ErrorResponse::failedValidation($validator->errors()->first());
    }
}
