using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class LanguageValidator : AbstractValidator<LanguageUpsertDto>
    {
        public LanguageValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        }
    }
}
