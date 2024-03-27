using eCinema.Core;
using FluentValidation;

namespace eCinema.Application.Validators
{
    public class MovieCategoryValidator : AbstractValidator<MovieCategoryUpsertDto>
    {
        public MovieCategoryValidator()
        {
            RuleFor(c => c.MovieId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.CategoryId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
