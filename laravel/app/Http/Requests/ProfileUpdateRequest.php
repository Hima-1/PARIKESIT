<?php

namespace App\Http\Requests;

use App\Http\Requests\Concerns\SanitizesInput;
use App\Models\User;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ProfileUpdateRequest extends FormRequest
{
    use SanitizesInput;

    protected function prepareForValidation(): void
    {
        $this->sanitizePlainTextFields(['name' => 255]);
        $this->sanitizeNullablePlainTextFields(['alamat' => 1000]);
        $this->sanitizeEmailField('email');
        $this->sanitizePhoneField('nomor_telepon', nullable: true);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\Rule|array|string>
     */
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'lowercase', 'email', 'max:255', Rule::unique(User::class)->ignore($this->user()->id)],
            'alamat' => ['nullable', 'string', 'max:1000'],
            'nomor_telepon' => ['nullable', 'string', 'max:20', 'regex:/^[0-9+()\-\s]{6,20}$/', Rule::unique(User::class)->ignore($this->user()->id)],
            'password' => ['nullable', 'string', 'min:8'], // Password optional, minimal 8 karakter jika diisi
        ];
    }
}
