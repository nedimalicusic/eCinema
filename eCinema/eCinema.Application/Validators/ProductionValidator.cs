using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ProductionValidator : AbstractValidator<ProductionUpsertDto>
    {
        public ProductionValidator()
        {
            RuleFor(c => c.Name).NotEmpty().NotNull();
            RuleFor(c => c.CountryId).NotNull();
        }
    }
}
