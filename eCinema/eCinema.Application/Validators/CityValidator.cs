using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class CityValidator : AbstractValidator<CityUpsertDto>
    {
        public CityValidator()
        {
            RuleFor(c => c.Name).NotEmpty().NotNull();
            RuleFor(c => c.ZipCode).NotEmpty().NotNull();
            RuleFor(c => c.IsActive).NotNull();
            RuleFor(c => c.CountryId).NotNull();
        }
    }
}
