using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class GenreValidator : AbstractValidator<GenreUpsertDto>
    {
        public GenreValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        }
    }
}
