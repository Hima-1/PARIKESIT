<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;

class StoreFormulirDomainRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        $formulir = $this->route('formulir');
        return Auth::user()->role === 'opd' && $formulir->created_by_id === Auth::id();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {
        return [
            'nama_domain' => 'required|string|max:255',
            'nama_aspek' => 'required|array|min:1',
            'nama_aspek.*' => 'required|string|max:255',
        ];
    }
}
