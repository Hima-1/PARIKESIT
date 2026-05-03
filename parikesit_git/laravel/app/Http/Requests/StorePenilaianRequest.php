<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;

class StorePenilaianRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        $formulir = $this->route('formulir');
        $user = Auth::user();

        if (!$user || !$formulir) {
            return false;
        }

        if ($user->role !== 'opd') {
            return false;
        }

        return (int) $formulir->created_by_id === (int) $user->id;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {
        return [
            'nilai' => 'required|numeric',
            'bukti_dukung' => 'nullable',
            'bukti_dukung.*' => 'nullable|file|mimes:pdf,jpg,jpeg,png,doc,docx|max:2048',
            'catatan' => 'nullable|string',
            'existing_bukti_dukung' => 'nullable|string',
        ];
    }
}
