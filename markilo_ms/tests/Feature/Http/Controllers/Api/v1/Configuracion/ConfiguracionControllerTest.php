<?php

namespace Tests\Feature\Http\Controllers\Api\v1\Configuracion;

use App\Models\Configuracion;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use JMac\Testing\Traits\AdditionalAssertions;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

/**
 * @see \App\Http\Controllers\Api\v1\Configuracion\ConfiguracionController
 */
final class ConfiguracionControllerTest extends TestCase
{
    use AdditionalAssertions, RefreshDatabase, WithFaker;

    #[Test]
    public function index_behaves_as_expected(): void
    {
        $configuracions = Configuracion::factory()->count(3)->create();

        $response = $this->get(route('configuracion.index'));

        $response->assertOk();
        $response->assertJsonStructure([]);
    }


    #[Test]
    public function store_uses_form_request_validation(): void
    {
        $this->assertActionUsesFormRequest(
            \App\Http\Controllers\Api\v1\Configuracion\ConfiguracionController::class,
            'store',
            \App\Http\Requests\Api\v1\Configuracion\ConfiguracionStoreRequest::class
        );
    }

    #[Test]
    public function store_saves(): void
    {
        $app_version = $this->faker->word();

        $response = $this->post(route('configuracion.store'), [
            'app_version' => $app_version,
        ]);

        $configuracions = Configuracion::query()
            ->where('app_version', $app_version)
            ->get();
        $this->assertCount(1, $configuracions);
        $configuracion = $configuracions->first();

        $response->assertCreated();
        $response->assertJsonStructure([]);
    }


    #[Test]
    public function show_behaves_as_expected(): void
    {
        $configuracion = Configuracion::factory()->create();

        $response = $this->get(route('configuracion.show', $configuracion));

        $response->assertOk();
        $response->assertJsonStructure([]);
    }


    #[Test]
    public function update_uses_form_request_validation(): void
    {
        $this->assertActionUsesFormRequest(
            \App\Http\Controllers\Api\v1\Configuracion\ConfiguracionController::class,
            'update',
            \App\Http\Requests\Api\v1\Configuracion\ConfiguracionUpdateRequest::class
        );
    }

    #[Test]
    public function update_behaves_as_expected(): void
    {
        $configuracion = Configuracion::factory()->create();
        $app_version = $this->faker->word();

        $response = $this->put(route('configuracion.update', $configuracion), [
            'app_version' => $app_version,
        ]);

        $configuracion->refresh();

        $response->assertOk();
        $response->assertJsonStructure([]);

        $this->assertEquals($app_version, $configuracion->app_version);
    }


    #[Test]
    public function destroy_deletes_and_responds_with(): void
    {
        $configuracion = Configuracion::factory()->create();

        $response = $this->delete(route('configuracion.destroy', $configuracion));

        $response->assertNoContent();

        $this->assertModelMissing($configuracion);
    }
}
