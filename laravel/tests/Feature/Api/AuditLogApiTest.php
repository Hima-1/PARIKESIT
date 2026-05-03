<?php

test('audit log api route is not registered', function () {
    $this->getJson('/api/audit-logs')->assertStatus(404);

    loginAsAdmin()->getJson('/api/audit-logs')->assertStatus(404);
});
