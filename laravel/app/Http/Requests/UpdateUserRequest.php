<?php

namespace App\Http\Requests;

use App\Http\Requests\Concerns\SanitizesInput;
use Illuminate\Foundation\Http\FormRequest;

class UpdateUserRequest extends FormRequest
{
    use SanitizesInput;

    protected function prepareForValidation(): void
    {
        $this->sanitizePlainTextFields([
            'name' => 255,
            'alamat' => 1000,
        ]);
        $this->sanitizeEmailField('email');
        $this->sanitizePhoneField('nomor_telepon');
    }

    public function authorize(): bool
    {
        return true; // Authorized by middleware
    }

    public function rules(): array
    {
        $userId = $this->route('user') ? $this->route('user')->id : null;

        return [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,'.$userId,
            'password' => 'nullable|string|min:8',
            'role' => 'required|string|in:admin,opd,walidata',
            'alamat' => 'required|string|max:1000',
            'nomor_telepon' => ['required', 'string', 'max:20', 'regex:/^[0-9+()\-\s]{6,20}$/'],
        ];
    }
}
