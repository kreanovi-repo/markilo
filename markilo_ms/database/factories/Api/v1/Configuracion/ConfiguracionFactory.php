<?php

namespace Database\Factories\Api\v1\Configuracion;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;
use App\Models\Api\v1\Configuracion\Configuracion;

class ConfiguracionFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Configuracion::class;

    /**
     * Define the model's default state.
     */
    public function definition(): array
    {
        return [
            'app_version' => $this->faker->regexify('[A-Za-z0-9]{10}'),
        ];
    }
}
