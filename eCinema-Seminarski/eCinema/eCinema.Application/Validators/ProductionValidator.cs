using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ProductionValidator : AbstractValidator<ProductionUpsertDto>
    {
        public ProductionValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.CountryId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
