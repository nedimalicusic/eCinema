using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class CountryValidator : AbstractValidator<CountryUpsertDto>
    {
        public CountryValidator()
        {
            RuleFor(c => c.Name).NotEmpty().NotNull();
            RuleFor(c => c.Abbreviation).NotEmpty().NotNull();
            RuleFor(c => c.IsActive).NotNull();
        }
    }
}
