<?php

namespace App\Services;

use App\Models\Formulir;
use App\Models\User;

class OpdAssessmentAccessService
{
    public function canAccessFullDisposisiOverview(User $user): bool
    {
        return in_array($user->role, ['admin', 'walidata'], true);
    }

    public function canAccessOpdAssessmentDetail(User $authUser, Formulir $formulir, User $targetUser): bool
    {
        if (!in_array($authUser->role, ['admin', 'walidata', 'opd'], true)) {
            return false;
        }

        if ($targetUser->role !== 'opd') {
            return false;
        }

        if ($this->canAccessFullDisposisiOverview($authUser)) {
            return $this->isFormulirRelatedToOpd($formulir, $targetUser);
        }

        if ((int) $authUser->id !== (int) $targetUser->id) {
            return false;
        }

        return $this->isFormulirRelatedToOpd($formulir, $targetUser);
    }

    public function isFormulirRelatedToOpd(Formulir $formulir, User $opd): bool
    {
        if ((int) $formulir->created_by_id === (int) $opd->id) {
            return true;
        }

        return $formulir->penilaians()
            ->where('user_id', $opd->id)
            ->exists();
    }
}
