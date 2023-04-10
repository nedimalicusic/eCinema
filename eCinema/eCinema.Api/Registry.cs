using System.Text;

using Microsoft.OpenApi.Models;
using Microsoft.IdentityModel.Tokens;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;

using eCinema.Application;
using eCinema.Common.Service;
using eCinema.Infrastructure;

namespace eCinema.Api
{
    public static class Registry
    {
        public static T BindConfig<T>(this WebApplicationBuilder builder, string key) where T : class
        {
            var section = builder.Configuration.GetSection(key);
            builder.Services.Configure<T>(section);
            return section.Get<T>()!;
        }

        public static void AddMapper(this IServiceCollection services)
        {
            services.AddAutoMapper(typeof(Program), typeof(BaseProfile));
        }

        public static void AddDatabase(this IServiceCollection services, ConnectionStringConfig config)
        {
            services.AddDbContext<DatabaseContext>(options => options.UseSqlServer(config.Main));
        }

        public static void AddAuthenticationAndAuthorization(this IServiceCollection services, JwtTokenConfig jwtTokenConfig)
        {
            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(o =>
            {
                o.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidIssuer = jwtTokenConfig.Issuer,
                    ValidAudience = jwtTokenConfig.Audience,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtTokenConfig.SecretKey)),
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = false,
                    ValidateIssuerSigningKey = true
                };
            });
            services.AddAuthorization();
        }

        public static void AddSwagger(this IServiceCollection services)
        {
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen(setup =>
            {
                var jwtSecurityScheme = new OpenApiSecurityScheme
                {
                    BearerFormat = "JWT",
                    Name = "JWT Authentication",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.Http,
                    Scheme = JwtBearerDefaults.AuthenticationScheme,
                    Reference = new OpenApiReference
                    {
                        Id = JwtBearerDefaults.AuthenticationScheme,
                        Type = ReferenceType.SecurityScheme
                    }
                };

                setup.AddSecurityDefinition(jwtSecurityScheme.Reference.Id, jwtSecurityScheme);
                setup.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    { jwtSecurityScheme, Array.Empty<string>() }
                });
            });
        }

        public static void AddOther(this IServiceCollection services)
        {
            services.AddScoped<IAccessManager, AccessManager>();
            services.AddSingleton<ICryptoService, CryptoService>();
        }
    }
}
