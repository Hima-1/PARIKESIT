<?php

namespace App\Http\Controllers;

use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use App\Services\DashboardService;
use Carbon\Carbon;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function __construct(
        private readonly DashboardService $dashboardService,
    ) {}

    public function index()
    {
        $data = $this->dashboardService->getStats();
        $data['title'] = 'Dashboard';
        $data['kegiatanPenilaian'] = Formulir::operational()->latest()->get();
        $data['users'] = User::doesntHave('penilaians')->latest()->get();
        $data['progressData'] = $this->dashboardService->getProgressData();

        return view('dashboard.dashboard', $data);
    }

    public function generatePenilaian(Request $request)
    {
        $indikators = Indikator::with('aspek.domain.formulirs')->get();

        foreach ($indikators as $indikator) {
            Penilaian::create([
                'indikator_id' => $indikator->id,
                'nilai' => rand(1, 5),
                'formulir_id' => $request->formulir_id,
                'tanggal_penilaian' => Carbon::now(),
                'user_id' => $request->user_id,
            ]);
        }

        return redirect()->back();
    }
}
